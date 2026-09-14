import 'package:flutter_test/flutter_test.dart';
import 'package:jezyki_krok_po_kroku/data/course_registry.dart';
import 'package:jezyki_krok_po_kroku/domain/learning/learning_engine.dart';
import 'package:jezyki_krok_po_kroku/state/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('registry contains four complete and independent starter courses', () {
    expect(courses.map((course) => course.id).toSet(), {
      'english',
      'spanish',
      'greek',
      'swedish',
    });

    for (final course in courses) {
      expect(course.modules, hasLength(3), reason: course.id);
      expect(course.lessons, hasLength(6), reason: course.id);
      expect(course.items, hasLength(30), reason: course.id);
      expect(course.lessons.map((lesson) => lesson.id).toSet(), hasLength(6));
      expect(course.items.map((item) => item.id).toSet(), hasLength(30));
      expect(course.speechLocale, contains('-'));
    }
  });

  test('learning engine creates mixed exercises with valid answers', () {
    final course = courses.first;
    final lesson = course.lessons.first;
    final exercises = LearningEngine.buildExercises(
      course: course,
      lesson: lesson,
      interfaceLanguage: 'pl',
    );

    expect(exercises, hasLength(lesson.items.length));
    expect(exercises.map((exercise) => exercise.type).toSet(), {
      ExerciseType.choice,
      ExerciseType.writing,
      ExerciseType.listening,
    });
    for (final exercise in exercises.where(
      (exercise) => exercise.type != ExerciseType.writing,
    )) {
      expect(exercise.options, contains(exercise.answer));
      expect(exercise.options.toSet(), hasLength(exercise.options.length));
    }
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
      );

      expect(controller.completedLessons(english), 1);
      expect(controller.completedLessons(spanish), 0);
      expect(controller.progressFor(english.id).masteredItems, hasLength(5));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('completedLessons'), isFalse);
      expect(prefs.containsKey('conceptStrength'), isFalse);

      final restored = await AppController.create();
      expect(restored.selectedCourse?.id, english.id);
      expect(restored.completedLessons(english), 1);
      expect(restored.completedLessons(spanish), 0);
    },
  );
}
