import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/course_registry.dart';
import '../domain/models/course.dart';

class AppController extends ChangeNotifier {
  AppController._(this._prefs);

  static const _schemaVersion = 2;
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

  bool isLessonCompleted(LanguageCourse course, CourseLesson lesson) =>
      progressFor(course.id).completedLessons.contains(lesson.id);

  Future<void> completeLesson({
    required LanguageCourse course,
    required CourseLesson lesson,
    required int correctAnswers,
  }) async {
    final progress = progressFor(course.id);
    progress.completedLessons.add(lesson.id);
    progress.minutesStudied += lesson.minutes;
    final previous = progress.bestScores[lesson.id] ?? 0;
    if (correctAnswers > previous) {
      progress.bestScores[lesson.id] = correctAnswers;
    }
    if (correctAnswers >= (lesson.items.length * 0.8).ceil()) {
      progress.masteredItems.addAll(lesson.items.map((item) => item.id));
    }
    await _saveProgress(course.id);
    notifyListeners();
  }

  Future<void> resetCourse(String courseId) async {
    _progress[courseId] = CourseProgress();
    await _write(() => _prefs.remove(_progressKey(courseId)));
    notifyListeners();
  }

  int completedLessons(LanguageCourse course) =>
      progressFor(course.id).completedLessons.length;

  double courseCompletion(LanguageCourse course) {
    if (course.lessons.isEmpty) return 0;
    return (completedLessons(course) / course.lessons.length).clamp(0, 1);
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
