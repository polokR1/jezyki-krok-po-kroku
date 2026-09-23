import '../models/course.dart';

class CourseValidator {
  const CourseValidator._();

  static List<String> validateAll(Iterable<LanguageCourse> courses) => [
    for (final course in courses) ...validate(course),
  ];

  static List<String> validate(LanguageCourse course) {
    final errors = <String>[];
    void expect(bool condition, String message) {
      if (!condition) errors.add('${course.id}: $message');
    }

    expect(course.modules.length == 32, 'expected 32 modules');
    expect(course.lessons.length == 128, 'expected 128 vocabulary lessons');
    expect(course.items.length == 640, 'expected 640 vocabulary items');
    expect(course.grammarLessons.length == 16, 'expected 16 grammar lessons');
    expect(course.dialogues.length == 4, 'expected 4 dialogues');
    expect(course.stories.length == 4, 'expected 4 stories');
    expect(course.activityCount == 152, 'expected 152 total activities');

    final activityIds = <String>[
      ...course.lessons.map((lesson) => lesson.id),
      ...course.grammarLessons.map((lesson) => lesson.id),
      ...course.dialogues.map((dialogue) => dialogue.id),
      ...course.stories.map((story) => story.id),
    ];
    expect(
      activityIds.toSet().length == activityIds.length,
      'duplicate activity id',
    );
    final itemIds = course.items.map((item) => item.id).toList();
    expect(itemIds.toSet().length == itemIds.length, 'duplicate vocabulary id');
    final moduleTitles = course.modules
        .map((module) => module.title.pl.trim().toLowerCase())
        .toList();
    expect(
      moduleTitles.toSet().length == moduleTitles.length,
      'duplicate Polish module title',
    );

    for (final module in course.modules) {
      expect(module.lessons.length == 4, '${module.id} should have 4 lessons');
      expect(
        module.description.pl.trim().isNotEmpty &&
            module.description.uk.trim().isNotEmpty,
        '${module.id} needs a bilingual description',
      );
      for (final lesson in module.lessons) {
        expect(lesson.items.length == 5, '${lesson.id} should have 5 items');
        expect(
          lesson.explanation.pl.trim().isNotEmpty &&
              lesson.explanation.uk.trim().isNotEmpty,
          '${lesson.id} needs a bilingual explanation',
        );
        for (final item in lesson.items) {
          expect(item.target.trim().isNotEmpty, '${item.id} has empty target');
          expect(
            item.translation.pl.trim().isNotEmpty,
            '${item.id} has empty Polish meaning',
          );
          expect(
            item.translation.uk.trim().isNotEmpty,
            '${item.id} has empty Ukrainian meaning',
          );
        }
      }
    }
    final firstModuleExercises = course.modules.first.lessons
        .expand((lesson) => lesson.items)
        .where((item) => item.target.trim().contains(RegExp(r'\s')))
        .length;
    expect(
      firstModuleExercises >= 5,
      'first module needs at least 5 multi-part targets for tiles',
    );
    if (course.id == 'greek') {
      expect(
        course.modules
            .take(5)
            .every((module) => module.id.startsWith('greek_alphabet_')),
        'Greek must begin with five alphabet modules',
      );
    }
    for (final dialogue in course.dialogues) {
      expect(dialogue.lines.length == 4, '${dialogue.id} should have 4 lines');
    }
    for (final story in course.stories) {
      expect(
        story.questions.length == 3,
        '${story.id} should have 3 questions',
      );
      for (final question in story.questions) {
        expect(
          question.options.length >= 2,
          '${story.id} question needs options',
        );
        expect(
          question.correctIndex >= 0 &&
              question.correctIndex < question.options.length,
          '${story.id} has invalid correct answer',
        );
      }
    }
    return errors;
  }
}
