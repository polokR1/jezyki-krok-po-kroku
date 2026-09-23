"""Build the checked-in multilingual vocabulary catalog.

The source vocabulary is the author's previous Swedish course. Polish and
Ukrainian meanings are preserved, while English, Spanish and Greek targets are
generated in topic-sized batches. The generated Dart file is committed, so the
application never needs a network connection at runtime.
"""

from __future__ import annotations

import argparse
import ast
import json
import re
import time
import urllib.parse
import urllib.request
from pathlib import Path

_translation_cache: dict[str, str] = {}
_cache_path: Path | None = None

_target_overrides = {
    "home_nyckel": {"es": "llave"},
    "home_golv": {"es": "suelo", "el": "πάτωμα"},
    "home_lampa": {"el": "λάμπα"},
    "home_vagg": {"el": "τοίχος"},
    "home_hyra": {"es": "alquiler"},
    "people_foralder": {"es": "progenitor"},
    "shop_kosta": {"en": "cost", "es": "costar", "el": "κοστίζω"},
    "service_lamna": {
        "en": "leave / submit",
        "es": "dejar / presentar",
        "el": "αφήνω / υποβάλλω",
    },
    "emotion_tycka": {"en": "like", "es": "gustar", "el": "μου αρέσει"},
    "emotion_sakna": {
        "en": "miss / lack",
        "es": "extrañar / faltar",
        "el": "μου λείπει / νοσταλγώ",
    },
    "tech_ladda": {
        "en": "charge / download",
        "es": "cargar / descargar",
        "el": "φορτίζω / κατεβάζω",
    },
    "tech_spara": {
        "en": "save / economise",
        "es": "guardar / ahorrar",
        "el": "αποθηκεύω / εξοικονομώ",
    },
    "tech_fungera": {"en": "work / function", "es": "funcionar", "el": "λειτουργώ"},
    "tech_fel": {"el": "σφάλμα / βλάβη"},
    "think_anse": {"en": "consider", "es": "considerar", "el": "θεωρώ"},
    "intro_spell": {"el": "συλλαβίζω"},
    "intro_fill_in": {"es": "rellenar", "el": "συμπληρώνω"},
    "intro_sign": {"el": "υπογράφω"},
    "emergency_smoke": {"es": "humo"},
    "emergency_injured": {"el": "τραυματισμένος"},
}


def _balanced_blocks(source: str, marker: str) -> list[str]:
    blocks: list[str] = []
    cursor = 0
    while True:
        start = source.find(marker, cursor)
        if start < 0:
            return blocks
        open_at = source.find("(", start)
        depth = 0
        quote: str | None = None
        escaped = False
        for index in range(open_at, len(source)):
            char = source[index]
            if quote:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == quote:
                    quote = None
                continue
            if char in {"'", '"'}:
                quote = char
            elif char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    blocks.append(source[start : index + 1])
                    cursor = index + 1
                    break
        else:
            raise ValueError(f"Unclosed {marker} block")


def _dart_value(block: str, field: str) -> str:
    match = re.search(rf"\b{re.escape(field)}:\s*('(?:\\.|[^'])*'|\"(?:\\.|[^\"])*\")", block)
    if not match:
        raise ValueError(f"Missing {field}")
    return ast.literal_eval(match.group(1))


def _item_values(block: str) -> tuple[str, str, str, str]:
    open_at = block.find("(") + 1
    payload = block[open_at:-1]
    values: list[str] = []
    index = 0
    while index < len(payload) and len(values) < 4:
        while index < len(payload) and (payload[index].isspace() or payload[index] == ","):
            index += 1
        if index >= len(payload) or payload[index] not in {"'", '"'}:
            raise ValueError(f"Expected string in {block[:80]!r}")
        quote = payload[index]
        start = index
        index += 1
        escaped = False
        while index < len(payload):
            char = payload[index]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                index += 1
                values.append(ast.literal_eval(payload[start:index]))
                break
            index += 1
    if len(values) != 4:
        raise ValueError(f"Expected four strings in {block[:80]!r}")
    return tuple(values)  # type: ignore[return-value]


def _translate(lines: list[str], target: str, source: str = "pl") -> list[str]:
    def request(text: str) -> str:
        cache_key = f"{source}>{target}\n{text}"
        if cache_key in _translation_cache:
            return _translation_cache[cache_key]
        query = urllib.parse.urlencode(
            {"client": "gtx", "sl": source, "tl": target, "dt": "t", "q": text}
        )
        url = f"https://translate.googleapis.com/translate_a/single?{query}"
        last_error: Exception | None = None
        for attempt in range(4):
            try:
                with urllib.request.urlopen(url, timeout=30) as response:
                    data = json.loads(response.read().decode("utf-8"))
                result = "".join(part[0] for part in data[0] if part and part[0]).strip()
                _translation_cache[cache_key] = result
                if _cache_path is not None:
                    _cache_path.write_text(
                        json.dumps(_translation_cache, ensure_ascii=False, indent=2),
                        encoding="utf-8",
                    )
                return result
            except Exception as error:  # network errors are retried and surfaced
                last_error = error
                time.sleep(1.5 * (attempt + 1))
        raise RuntimeError(f"Translation to {target} failed: {last_error}")

    translated = request("\n".join(lines)).splitlines()
    if len(translated) == len(lines) and all(value.strip() for value in translated):
        return [value.strip() for value in translated]
    return [request(line) for line in lines]


def _dart_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False).replace("$", r"\$")


def _looks_like_polish_verb(value: str) -> bool:
    if value.strip().lower() in {"cześć", "pięć", "sześć", "dziesięć"}:
        return False
    return re.search(r"\b[ąćęłńóśźża-z]+ć\b", value.lower()) is not None


def _verb_translations(polish: list[str], target: str) -> dict[int, str]:
    indices = [index for index, value in enumerate(polish) if _looks_like_polish_verb(value)]
    if not indices:
        return {}
    contextual = [f"czasownik: {polish[index]}" for index in indices]
    translated = _translate(contextual, target, source="pl")
    cleaned = []
    for value in translated:
        cleaned.append(value.split(":", 1)[-1].strip())
    return dict(zip(indices, cleaned))


def main() -> None:
    global _cache_path
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    _cache_path = Path('.dart_tool/generated_translation_cache.json')
    _cache_path.parent.mkdir(parents=True, exist_ok=True)
    if _cache_path.exists():
        _translation_cache.update(json.loads(_cache_path.read_text(encoding="utf-8")))

    source = args.source.read_text(encoding="utf-8")
    topics = []
    for topic_block in _balanced_blocks(source, "VocabularyTopic("):
        words = [_item_values(block) for block in _balanced_blocks(topic_block, "VocabularyItem(")]
        if len(words) != 20:
            raise ValueError(f"Topic {_dart_value(topic_block, 'id')} has {len(words)} words")
        polish = [word[2] for word in words]
        english = _translate(polish, "en")
        spanish = _translate(english, "es", source="en")
        greek = _translate(english, "el", source="en")
        for target, values in (("en", english), ("es", spanish), ("el", greek)):
            for index, value in _verb_translations(polish, target).items():
                values[index] = value
            for index, word in enumerate(words):
                override = _target_overrides.get(word[0], {}).get(target)
                if override is not None:
                    values[index] = override
        topics.append(
            {
                "id": _dart_value(topic_block, "id"),
                "titlePl": _dart_value(topic_block, "title"),
                "titleUk": _dart_value(topic_block, "titleUkrainian"),
                "level": _dart_value(topic_block, "level"),
                "words": [
                    (*word, english[index], spanish[index], greek[index])
                    for index, word in enumerate(words)
                ],
            }
        )

    if len(topics) != 32:
        raise ValueError(f"Expected 32 topics, got {len(topics)}")

    lines = [
        "// GENERATED FILE. Run tool/generate_multilingual_vocabulary.py to rebuild.",
        "import '../curriculum_seed.dart';",
        "",
        "const multilingualVocabularyTopics = <MultilingualTopicSeed>[",
    ]
    for topic in topics:
        lines.extend(
            [
                "  MultilingualTopicSeed(",
                f"    id: {_dart_string(topic['id'])},",
                f"    titlePl: {_dart_string(topic['titlePl'])},",
                f"    titleUk: {_dart_string(topic['titleUk'])},",
                f"    level: {_dart_string(topic['level'])},",
                "    words: [",
            ]
        )
        for word in topic["words"]:
            item_id, swedish, polish, ukrainian, english, spanish, greek = word
            lines.append(
                "      MultilingualWordSeed("
                + ", ".join(_dart_string(value) for value in (item_id, polish, ukrainian, english, spanish, greek, swedish))
                + "),"
            )
        lines.extend(["    ],", "  ),"])
    lines.extend(["];"])
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Generated {len(topics)} topics and {sum(len(t['words']) for t in topics)} words")


if __name__ == "__main__":
    main()
