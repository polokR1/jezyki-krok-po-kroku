import '../models/course.dart';

enum ExerciseType { choice, reverseChoice, writing, listening, wordOrder }

class LearningExercise {
  const LearningExercise({
    required this.type,
    required this.item,
    required this.prompt,
    required this.answer,
    this.options = const [],
  });

  final ExerciseType type;
  final LearningItem item;
  final String prompt;
  final String answer;
  final List<String> options;
}

class LearningEngine {
  const LearningEngine._();

  static List<LearningExercise> buildExercises({
    required LanguageCourse course,
    required CourseLesson lesson,
    required String interfaceLanguage,
  }) {
    final allTranslations = course.items
        .map((item) => item.translation.resolve(interfaceLanguage))
        .toSet()
        .toList();
    final allTargets = course.items.map((item) => item.target).toSet().toList();

    return [
      for (var index = 0; index < lesson.items.length; index++)
        ..._exercisesFor(
          item: lesson.items[index],
          index: index,
          translations: allTranslations,
          targets: allTargets,
          interfaceLanguage: interfaceLanguage,
        ),
    ];
  }

  static List<LearningExercise> _exercisesFor({
    required LearningItem item,
    required int index,
    required List<String> translations,
    required List<String> targets,
    required String interfaceLanguage,
  }) {
    final translation = item.translation.resolve(interfaceLanguage);
    final firstType = <ExerciseType>[
      ExerciseType.choice,
      ExerciseType.listening,
      ExerciseType.reverseChoice,
      ExerciseType.choice,
      ExerciseType.listening,
    ][index % 5];
    final productionType = item.target.trim().contains(' ')
        ? ExerciseType.wordOrder
        : ExerciseType.writing;

    return [
      if (firstType == ExerciseType.reverseChoice)
        LearningExercise(
          type: firstType,
          item: item,
          prompt: translation,
          answer: item.target,
          options: _optionsFor(
            answer: item.target,
            candidates: targets,
            seed: index,
          ),
        )
      else
        LearningExercise(
          type: firstType,
          item: item,
          prompt: item.target,
          answer: translation,
          options: _optionsFor(
            answer: translation,
            candidates: translations,
            seed: index,
          ),
        ),
      LearningExercise(
        type: productionType,
        item: item,
        prompt: translation,
        answer: item.target,
      ),
    ];
  }

  static List<String> _optionsFor({
    required String answer,
    required List<String> candidates,
    required int seed,
  }) {
    final distractors = candidates.where((value) => value != answer).toList();
    final options = <String>[answer];
    for (
      var offset = 0;
      offset < distractors.length && options.length < 3;
      offset++
    ) {
      options.add(distractors[(seed + offset) % distractors.length]);
    }
    options.sort(
      (a, b) => _stableOrder('$seed:$a').compareTo(_stableOrder('$seed:$b')),
    );
    return options;
  }

  static bool answersMatch(String actual, String expected) =>
      _normalize(actual) == _normalize(expected);

  static int _stableOrder(String value) =>
      value.codeUnits.fold(0, (sum, unit) => sum + unit);

  static String _normalize(String value) {
    const replacements = <String, String>{
      'ą': 'a',
      'ć': 'c',
      'ę': 'e',
      'ł': 'l',
      'ń': 'n',
      'ó': 'o',
      'ś': 's',
      'ź': 'z',
      'ż': 'z',
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ú': 'u',
      'ü': 'u',
      'ä': 'a',
      'å': 'a',
      'ö': 'o',
      'ή': 'η',
      'ί': 'ι',
      'ύ': 'υ',
      'ό': 'ο',
      'ώ': 'ω',
      'έ': 'ε',
      'ά': 'α',
      'ϊ': 'ι',
      'ΐ': 'ι',
      'ϋ': 'υ',
      'ΰ': 'υ',
      'ς': 'σ',
    };
    var normalized = value.toLowerCase().trim();
    replacements.forEach(
      (from, to) => normalized = normalized.replaceAll(from, to),
    );
    return normalized
        .replaceAll(RegExp(r'[^a-z0-9α-ωа-яіїєґ\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
