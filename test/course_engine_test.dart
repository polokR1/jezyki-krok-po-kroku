import 'package:flutter_test/flutter_test.dart';
import 'package:jezyki_krok_po_kroku/data/course_registry.dart';
import 'package:jezyki_krok_po_kroku/domain/learning/learning_engine.dart';
import 'package:jezyki_krok_po_kroku/domain/models/course.dart';
import 'package:jezyki_krok_po_kroku/domain/validation/course_validator.dart';
import 'package:jezyki_krok_po_kroku/state/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'registry contains four complete and independent vocabulary courses',
    () {
      expect(courses.map((course) => course.id).toSet(), {
        'english',
        'spanish',
        'greek',
        'swedish',
      });

      for (final course in courses) {
        expect(course.modules, hasLength(32), reason: course.id);
        expect(course.lessons, hasLength(128), reason: course.id);
        expect(course.items, hasLength(640), reason: course.id);
        expect(course.grammarLessons, hasLength(16), reason: course.id);
        expect(course.dialogues, hasLength(4), reason: course.id);
        expect(course.stories, hasLength(4), reason: course.id);
        expect(course.activityCount, 152, reason: course.id);
        expect(
          course.lessons.map((lesson) => lesson.id).toSet(),
          hasLength(128),
        );
        expect(course.items.map((item) => item.id).toSet(), hasLength(640));
        expect(
          course.modules.every((module) => module.lessons.length == 4),
          isTrue,
        );
        expect(
          course.lessons.every((lesson) => lesson.items.length == 5),
          isTrue,
        );
        expect(
          course.lessons.every(
            (lesson) =>
                lesson.explanation.pl.trim().isNotEmpty &&
                lesson.explanation.uk.trim().isNotEmpty,
          ),
          isTrue,
        );
        expect(
          course.modules.map((module) => module.title.pl).toSet(),
          hasLength(course.modules.length),
        );
        expect(course.speechLocale, contains('-'));
      }
      final greek = courses.firstWhere((course) => course.id == 'greek');
      expect(
        greek.modules.take(5).map((module) => module.id),
        everyElement(startsWith('greek_alphabet_')),
      );
    },
  );

  test('learning engine creates mixed exercises with valid answers', () {
    final course = courses.first;
    final lesson = course.lessons.first;
    final exercises = LearningEngine.buildExercises(
      course: course,
      lesson: lesson,
      interfaceLanguage: 'pl',
    );

    expect(exercises, hasLength(lesson.items.length * 2));
    expect(exercises.map((exercise) => exercise.type).toSet(), {
      ExerciseType.choice,
      ExerciseType.reverseChoice,
      ExerciseType.writing,
      ExerciseType.listening,
      ExerciseType.wordOrder,
    });
    for (final exercise in exercises.where(
      (exercise) =>
          exercise.type != ExerciseType.writing &&
          exercise.type != ExerciseType.wordOrder,
    )) {
      expect(exercise.options, contains(exercise.answer));
      expect(exercise.options.toSet(), hasLength(exercise.options.length));
    }
  });

  test('all course data passes structural validation', () {
    expect(CourseValidator.validateAll(courses), isEmpty);
  });

  test('every course begins with sentence or symbol tiles', () {
    for (final course in courses) {
      final exercises = course.modules.first.lessons.expand(
        (lesson) => LearningEngine.buildExercises(
          course: course,
          lesson: lesson,
          interfaceLanguage: 'pl',
        ),
      );
      expect(
        exercises.where((exercise) => exercise.type == ExerciseType.wordOrder),
        isNotEmpty,
        reason: course.id,
      );
    }
  });

  test('known ambiguous translations keep the intended meaning', () {
    for (final course in courses) {
      final six = course.items.firstWhere(
        (item) => item.id.endsWith('num_sex'),
      );
      expect(six.target, switch (course.id) {
        'english' => 'six',
        'spanish' => 'seis',
        'greek' => 'έξι',
        'swedish' => 'sex',
        _ => fail('Unknown course'),
      });
    }
  });

  test('spaced repetition schedules weak and strong items separately', () {
    final progress = CourseProgress();
    final now = DateTime(2026, 9, 14, 12);
    progress.recordAnswer(itemId: 'word', correct: false, now: now);
    expect(progress.isDue('word', now: now), isTrue);
    for (var index = 0; index < 4; index++) {
      progress.recordAnswer(itemId: 'word', correct: true, now: now);
    }
    expect(progress.masteredItems, contains('word'));
    expect(progress.isDue('word', now: now), isFalse);
    expect(progress.accuracy, 80);
  });

  test('answer comparison tolerates case, punctuation and accents', () {
    expect(LearningEngine.answersMatch('  ADIÓS! ', 'adios'), isTrue);
    expect(LearningEngine.answersMatch('Καλημέρα!', 'καλημερα'), isTrue);
    expect(LearningEngine.answersMatch('wrong', 'right'), isFalse);
  });

  test(
    'legacy Swedish state is removed and course progress stays separate',
    () async {
      SharedPreferences.setMockInitialValues({
        'completedLessons': ['legacy_lesson'],
        'conceptStrength': '{"legacy":5}',
        'onboardingDone': true,
      });
      final controller = await AppController.create();
      final english = courses.firstWhere((course) => course.id == 'english');
      final spanish = courses.firstWhere((course) => course.id == 'spanish');

      expect(controller.selectedCourse, isNull);
      await controller.selectCourse(english.id);
      await controller.completeLesson(
        course: english,
        lesson: english.lessons.first,
        correctAnswers: english.lessons.first.items.length,
        totalQuestions: english.lessons.first.items.length,
      );

      expect(controller.completedLessons(english), 1);
      expect(controller.completedLessons(spanish), 0);
      expect(controller.progressFor(english.id).masteredItems, isEmpty);
      expect(controller.isLessonAvailable(english, english.lessons[1]), isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('completedLessons'), isFalse);
      expect(prefs.containsKey('conceptStrength'), isFalse);

      final restored = await AppController.create();
      expect(restored.selectedCourse?.id, english.id);
      expect(restored.completedLessons(english), 1);
      expect(restored.completedLessons(spanish), 0);
    },
  );

  test('a weak result does not unlock the next step', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();
    final course = courses.first;

    expect(controller.isLessonAvailable(course, course.lessons.first), isTrue);
    expect(controller.isLessonAvailable(course, course.lessons[1]), isFalse);
    await controller.completeLesson(
      course: course,
      lesson: course.lessons.first,
      correctAnswers: 7,
      totalQuestions: 10,
    );

    expect(controller.isLessonCompleted(course, course.lessons.first), isFalse);
    expect(controller.isLessonAvailable(course, course.lessons[1]), isFalse);
  });
}
