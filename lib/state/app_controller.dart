import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/course_registry.dart';
import '../domain/models/course.dart';

class AppController extends ChangeNotifier {
  AppController._(this._prefs);

  static const _schemaVersion = 3;
  static const _schemaKey = 'multicourse.schemaVersion';
  static const _legacyKeys = <String>[
    'onboardingDone',
    'level',
    'focus',
    'dailyGoal',
    'newWordsPerDay',
    'repetitionIntensity',
    'autoplaySpeech',
    'listeningExercises',
    'writingExercises',
    'autoDifficulty',
    'reminders',
    'reminderTimes',
    'correctAnswers',
    'totalAnswers',
    'minutesStudied',
    'minutesToday',
    'streak',
    'lastStudyDate',
    'dailyStatsDate',
    'completedLessons',
    'todayWordIds',
    'errorCounts',
    'conceptStrength',
    'nextReviewAt',
    'wordReceptiveCorrect',
    'wordProductiveCorrect',
    'skillCorrect',
    'skillAttempts',
    'completedDialogues',
    'completedStories',
  ];

  final SharedPreferences _prefs;
  final Map<String, CourseProgress> _progress = {};

  String interfaceLanguage = 'pl';
  String? selectedCourseId;
  String themePreference = 'system';
  double speechRate = 0.42;
  int dailyGoalMinutes = 15;
  String? storageWarning;

  static Future<AppController> create() async {
    final prefs = await SharedPreferences.getInstance();
    final controller = AppController._(prefs);
    await controller._load();
    return controller;
  }

  Future<void> _load() async {
    try {
      if ((_prefs.getInt(_schemaKey) ?? 0) < _schemaVersion) {
        for (final key in _legacyKeys) {
          await _prefs.remove(key);
        }
        await _prefs.setInt(_schemaKey, _schemaVersion);
      }
      interfaceLanguage =
          _prefs.getString('multicourse.interfaceLanguage') ?? 'pl';
      selectedCourseId = _prefs.getString('multicourse.selectedCourse');
      if (courseById(selectedCourseId) == null) selectedCourseId = null;
      themePreference = _prefs.getString('multicourse.theme') ?? 'system';
      speechRate = _prefs.getDouble('multicourse.speechRate') ?? 0.42;
      dailyGoalMinutes = _prefs.getInt('multicourse.dailyGoalMinutes') ?? 15;
      for (final course in courses) {
        _progress[course.id] = CourseProgress.decode(
          _prefs.getString(_progressKey(course.id)),
        );
      }
    } on Object catch (error) {
      storageWarning = 'Nie udało się odczytać zapisanych ustawień: $error';
      for (final course in courses) {
        _progress[course.id] = CourseProgress();
      }
    }
  }

  LanguageCourse? get selectedCourse => courseById(selectedCourseId);
  CourseProgress progressFor(String courseId) =>
      _progress.putIfAbsent(courseId, CourseProgress.new);

  ThemeMode get themeMode => switch (themePreference) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Future<void> selectCourse(String courseId) async {
    if (courseById(courseId) == null) {
      storageWarning = 'Nie znaleziono wybranego kursu.';
      notifyListeners();
      return;
    }
    selectedCourseId = courseId;
    await _write(
      () => _prefs.setString('multicourse.selectedCourse', courseId),
    );
    notifyListeners();
  }

  Future<void> clearCourseSelection() async {
    selectedCourseId = null;
    await _write(() => _prefs.remove('multicourse.selectedCourse'));
    notifyListeners();
  }

  Future<void> setInterfaceLanguage(String language) async {
    if (language != 'pl' && language != 'uk') return;
    interfaceLanguage = language;
    await _write(
      () => _prefs.setString('multicourse.interfaceLanguage', language),
    );
    notifyListeners();
  }

  Future<void> setThemePreference(String value) async {
    if (!const {'system', 'light', 'dark'}.contains(value)) return;
    themePreference = value;
    await _write(() => _prefs.setString('multicourse.theme', value));
    notifyListeners();
  }

  Future<void> setSpeechRate(double value) async {
    speechRate = value.clamp(0.25, 0.6);
    await _write(() => _prefs.setDouble('multicourse.speechRate', speechRate));
    notifyListeners();
  }

  Future<void> setDailyGoalMinutes(int value) async {
    if (!const {5, 10, 15, 20, 30}.contains(value)) return;
    dailyGoalMinutes = value;
    await _write(() => _prefs.setInt('multicourse.dailyGoalMinutes', value));
    notifyListeners();
  }

  Future<void> recordAnswer({
    required String courseId,
    required String itemId,
    required bool correct,
  }) async {
    if (courseById(courseId) == null) return;
    progressFor(courseId).recordAnswer(itemId: itemId, correct: correct);
    await _saveProgress(courseId);
    notifyListeners();
  }

  bool isLessonCompleted(LanguageCourse course, CourseLesson lesson) =>
      progressFor(course.id).completedLessons.contains(lesson.id);

  bool isLessonAvailable(LanguageCourse course, CourseLesson lesson) {
    final index = course.lessons.indexWhere(
      (candidate) => candidate.id == lesson.id,
    );
    if (index <= 0) return index == 0;
    return progressFor(
      course.id,
    ).completedLessons.contains(course.lessons[index - 1].id);
  }

  bool isActivityCompleted(String courseId, String activityId) =>
      progressFor(courseId).completedLessons.contains(activityId);

  Future<void> completeActivity({
    required LanguageCourse course,
    required String activityId,
    int minutes = 8,
  }) async {
    final progress = progressFor(course.id);
    if (progress.completedLessons.add(activityId)) {
      progress.addStudyMinutes(minutes);
    }
    await _saveProgress(course.id);
    notifyListeners();
  }

  Future<void> completeLesson({
    required LanguageCourse course,
    required CourseLesson lesson,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final progress = progressFor(course.id);
    progress.addStudyMinutes(lesson.minutes);
    final score = totalQuestions == 0
        ? 0
        : ((correctAnswers / totalQuestions) * 100).round();
    if (score >= 80) {
      progress.completedLessons.add(lesson.id);
    } else {
      progress.completedLessons.remove(lesson.id);
    }
    final previous = progress.bestScores[lesson.id] ?? 0;
    if (score > previous) {
      progress.bestScores[lesson.id] = score;
    }
    await _saveProgress(course.id);
    notifyListeners();
  }

  Future<void> resetCourse(String courseId) async {
    _progress[courseId] = CourseProgress();
    await _write(() => _prefs.remove(_progressKey(courseId)));
    notifyListeners();
  }

  int completedLessons(LanguageCourse course) {
    final completed = progressFor(course.id).completedLessons;
    return course.lessons
        .where((lesson) => completed.contains(lesson.id))
        .length;
  }

  int completedActivities(LanguageCourse course) => progressFor(course.id)
      .completedLessons
      .where(
        (id) =>
            course.lessons.any((lesson) => lesson.id == id) ||
            course.grammarLessons.any((lesson) => lesson.id == id) ||
            course.dialogues.any((dialogue) => dialogue.id == id) ||
            course.stories.any((story) => story.id == id),
      )
      .length;

  double courseCompletion(LanguageCourse course) {
    if (course.activityCount == 0) return 0;
    return (completedActivities(course) / course.activityCount).clamp(0, 1);
  }

  int dueReviews(LanguageCourse course) => course.items
      .where((item) => progressFor(course.id).isDue(item.id))
      .length;

  int masteredItems(LanguageCourse course) {
    final validIds = course.items.map((item) => item.id).toSet();
    return progressFor(course.id).masteredItems.where(validIds.contains).length;
  }

  Future<void> _saveProgress(String courseId) => _write(
    () => _prefs.setString(
      _progressKey(courseId),
      progressFor(courseId).encode(),
    ),
  );

  Future<void> _write(Future<bool> Function() action) async {
    try {
      final saved = await action();
      storageWarning = saved ? null : 'System nie potwierdził zapisu ustawień.';
    } on Object catch (error) {
      storageWarning = 'Nie udało się zapisać danych: $error';
    }
  }

  static String _progressKey(String courseId) =>
      'multicourse.progress.$courseId';
}
