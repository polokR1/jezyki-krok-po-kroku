import 'dart:convert';

class LocalizedText {
  const LocalizedText({required this.pl, required this.uk});

  final String pl;
  final String uk;

  String resolve(String interfaceLanguage) =>
      interfaceLanguage == 'uk' ? uk : pl;
}

class LearningItem {
  const LearningItem({
    required this.id,
    required this.target,
    required this.translation,
    this.pronunciation,
    this.exampleTarget,
    this.exampleTranslation,
  });

  final String id;
  final String target;
  final LocalizedText translation;
  final String? pronunciation;
  final String? exampleTarget;
  final LocalizedText? exampleTranslation;
}

class CourseLesson {
  const CourseLesson({
    required this.id,
    required this.title,
    required this.objective,
    required this.items,
    this.minutes = 6,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText objective;
  final List<LearningItem> items;
  final int minutes;
}

class CourseModule {
  const CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.lessons,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final String level;
  final List<CourseLesson> lessons;
}

class LanguageCourse {
  const LanguageCourse({
    required this.id,
    required this.languageCode,
    required this.speechLocale,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.colorValue,
    required this.modules,
  });

  final String id;
  final String languageCode;
  final String speechLocale;
  final LocalizedText name;
  final String nativeName;
  final String flag;
  final int colorValue;
  final List<CourseModule> modules;

  List<CourseLesson> get lessons => [
    for (final module in modules) ...module.lessons,
  ];

  List<LearningItem> get items => [
    for (final lesson in lessons) ...lesson.items,
  ];

  CourseModule moduleFor(CourseLesson lesson) => modules.firstWhere(
    (module) => module.lessons.any((candidate) => candidate.id == lesson.id),
  );
}

class CourseProgress {
  CourseProgress({
    Set<String>? completedLessons,
    Set<String>? masteredItems,
    Map<String, int>? bestScores,
    this.minutesStudied = 0,
  }) : completedLessons = completedLessons ?? <String>{},
       masteredItems = masteredItems ?? <String>{},
       bestScores = bestScores ?? <String, int>{};

  final Set<String> completedLessons;
  final Set<String> masteredItems;
  final Map<String, int> bestScores;
  int minutesStudied;

  Map<String, Object> toJson() => {
    'completedLessons': completedLessons.toList()..sort(),
    'masteredItems': masteredItems.toList()..sort(),
    'bestScores': bestScores,
    'minutesStudied': minutesStudied,
  };

  String encode() => jsonEncode(toJson());

  static CourseProgress decode(String? raw) {
    if (raw == null || raw.isEmpty) return CourseProgress();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CourseProgress(
        completedLessons: Set<String>.from(
          (json['completedLessons'] as List<dynamic>? ?? const []),
        ),
        masteredItems: Set<String>.from(
          (json['masteredItems'] as List<dynamic>? ?? const []),
        ),
        bestScores: (json['bestScores'] as Map<String, dynamic>? ?? const {})
            .map((key, value) => MapEntry(key, (value as num).toInt())),
        minutesStudied: (json['minutesStudied'] as num?)?.toInt() ?? 0,
      );
    } on Object {
      return CourseProgress();
    }
  }
}
