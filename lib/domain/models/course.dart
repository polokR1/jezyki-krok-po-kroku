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
    this.explanation = const LocalizedText(
      pl: 'Najpierw zapoznaj się z materiałem, potem odtwórz go z pamięci.',
      uk: 'Спочатку ознайомся з матеріалом, потім відтвори його з пам’яті.',
    ),
    this.minutes = 6,
  });

  final String id;
  final LocalizedText title;
  final LocalizedText objective;
  final LocalizedText explanation;
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

class GrammarLesson {
  const GrammarLesson({
    required this.id,
    required this.level,
    required this.title,
    required this.explanation,
    required this.exampleTarget,
    required this.exampleTranslation,
  });

  final String id;
  final String level;
  final LocalizedText title;
  final LocalizedText explanation;
  final String exampleTarget;
  final LocalizedText exampleTranslation;
}

class DialogueLine {
  const DialogueLine({
    required this.speaker,
    required this.target,
    required this.translation,
  });

  final String speaker;
  final String target;
  final LocalizedText translation;
}

class DialogueScenario {
  const DialogueScenario({
    required this.id,
    required this.level,
    required this.title,
    required this.situation,
    required this.lines,
  });

  final String id;
  final String level;
  final LocalizedText title;
  final LocalizedText situation;
  final List<DialogueLine> lines;
}

class StoryQuestion {
  const StoryQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final LocalizedText prompt;
  final List<LocalizedText> options;
  final int correctIndex;
}

class CourseStory {
  const CourseStory({
    required this.id,
    required this.level,
    required this.title,
    required this.targetText,
    required this.translation,
    required this.questions,
  });

  final String id;
  final String level;
  final LocalizedText title;
  final String targetText;
  final LocalizedText translation;
  final List<StoryQuestion> questions;
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
    this.grammarLessons = const [],
    this.dialogues = const [],
    this.stories = const [],
  });

  final String id;
  final String languageCode;
  final String speechLocale;
  final LocalizedText name;
  final String nativeName;
  final String flag;
  final int colorValue;
  final List<CourseModule> modules;
  final List<GrammarLesson> grammarLessons;
  final List<DialogueScenario> dialogues;
  final List<CourseStory> stories;

  List<CourseLesson> get lessons => [
    for (final module in modules) ...module.lessons,
  ];

  List<LearningItem> get items => [
    for (final lesson in lessons) ...lesson.items,
  ];

  int get activityCount =>
      lessons.length +
      grammarLessons.length +
      dialogues.length +
      stories.length;

  CourseModule moduleFor(CourseLesson lesson) => modules.firstWhere(
    (module) => module.lessons.any((candidate) => candidate.id == lesson.id),
  );
}

class CourseProgress {
  CourseProgress({
    Set<String>? completedLessons,
    Set<String>? masteredItems,
    Map<String, int>? bestScores,
    Map<String, int>? itemStrength,
    Map<String, int>? nextReviewAt,
    this.minutesStudied = 0,
    this.minutesToday = 0,
    this.correctAnswers = 0,
    this.totalAnswers = 0,
    this.streak = 0,
    this.lastStudyDate,
  }) : completedLessons = completedLessons ?? <String>{},
       masteredItems = masteredItems ?? <String>{},
       bestScores = bestScores ?? <String, int>{},
       itemStrength = itemStrength ?? <String, int>{},
       nextReviewAt = nextReviewAt ?? <String, int>{};

  final Set<String> completedLessons;
  final Set<String> masteredItems;
  final Map<String, int> bestScores;
  final Map<String, int> itemStrength;
  final Map<String, int> nextReviewAt;
  int minutesStudied;
  int minutesToday;
  int correctAnswers;
  int totalAnswers;
  int streak;
  String? lastStudyDate;

  int get accuracy =>
      totalAnswers == 0 ? 0 : ((correctAnswers / totalAnswers) * 100).round();

  void recordAnswer({
    required String itemId,
    required bool correct,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    totalAnswers++;
    if (correct) correctAnswers++;
    final previous = itemStrength[itemId] ?? 0;
    final strength = correct
        ? (previous + 1).clamp(0, 5)
        : (previous - 2).clamp(0, 5);
    itemStrength[itemId] = strength;
    if (strength >= 4) {
      masteredItems.add(itemId);
    } else {
      masteredItems.remove(itemId);
    }
    const intervals = <int>[0, 1, 3, 7, 14, 30];
    nextReviewAt[itemId] = date
        .add(Duration(days: correct ? intervals[strength] : 0))
        .millisecondsSinceEpoch;
    _recordStudyDay(date);
  }

  bool isDue(String itemId, {DateTime? now}) {
    final due = nextReviewAt[itemId];
    return due != null && due <= (now ?? DateTime.now()).millisecondsSinceEpoch;
  }

  void addStudyMinutes(int minutes, {DateTime? now}) {
    _recordStudyDay(now ?? DateTime.now());
    minutesStudied += minutes;
    minutesToday += minutes;
  }

  void _recordStudyDay(DateTime date) {
    final day = _dayKey(date);
    if (lastStudyDate == day) return;
    final yesterday = _dayKey(date.subtract(const Duration(days: 1)));
    streak = lastStudyDate == yesterday ? streak + 1 : 1;
    lastStudyDate = day;
    minutesToday = 0;
  }

  static String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Map<String, Object?> toJson() => {
    'completedLessons': completedLessons.toList()..sort(),
    'masteredItems': masteredItems.toList()..sort(),
    'bestScores': bestScores,
    'itemStrength': itemStrength,
    'nextReviewAt': nextReviewAt,
    'minutesStudied': minutesStudied,
    'minutesToday': minutesToday,
    'correctAnswers': correctAnswers,
    'totalAnswers': totalAnswers,
    'streak': streak,
    'lastStudyDate': lastStudyDate,
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
        itemStrength:
            (json['itemStrength'] as Map<String, dynamic>? ?? const {}).map(
              (key, value) => MapEntry(key, (value as num).toInt()),
            ),
        nextReviewAt:
            (json['nextReviewAt'] as Map<String, dynamic>? ?? const {}).map(
              (key, value) => MapEntry(key, (value as num).toInt()),
            ),
        minutesStudied: (json['minutesStudied'] as num?)?.toInt() ?? 0,
        minutesToday: (json['minutesToday'] as num?)?.toInt() ?? 0,
        correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
        totalAnswers: (json['totalAnswers'] as num?)?.toInt() ?? 0,
        streak: (json['streak'] as num?)?.toInt() ?? 0,
        lastStudyDate: json['lastStudyDate'] as String?,
      );
    } on Object {
      return CourseProgress();
    }
  }
}
