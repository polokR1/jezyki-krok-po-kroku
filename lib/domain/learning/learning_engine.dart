import '../models/course.dart';

enum ExerciseType { choice, writing, listening }

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

    return [
      for (var index = 0; index < lesson.items.length; index++)
        _exerciseFor(
          lesson.items[index],
          index,
          allTranslations,
          interfaceLanguage,
        ),
    ];
  }

  static LearningExercise _exerciseFor(
    LearningItem item,
    int index,
    List<String> translations,
    String interfaceLanguage,
  ) {
    final translation = item.translation.resolve(interfaceLanguage);
    final type = ExerciseType.values[index % ExerciseType.values.length];
    if (type == ExerciseType.writing) {
      return LearningExercise(
        type: type,
        item: item,
        prompt: translation,
        answer: item.target,
      );
    }

    final distractors = translations
        .where((value) => value != translation)
        .toList();
    final options = <String>[translation];
    for (
      var offset = 0;
      offset < distractors.length && options.length < 3;
      offset++
    ) {
      options.add(distractors[(index + offset) % distractors.length]);
    }
    options.sort(
      (a, b) => _stableOrder('$index:$a').compareTo(_stableOrder('$index:$b')),
    );
    return LearningExercise(
      type: type,
      item: item,
      prompt: item.target,
      answer: translation,
      options: options,
    );
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
