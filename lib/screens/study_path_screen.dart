import 'package:flutter/material.dart';

import '../domain/models/course.dart';
import '../l10n/app_localization.dart';
import '../state/app_controller.dart';
import 'lesson_screen.dart';

class StudyPathScreen extends StatelessWidget {
  const StudyPathScreen({super.key, required this.controller});
  final AppController controller;

  void _openLesson(
    BuildContext context,
    LanguageCourse course,
    CourseLesson lesson,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          controller: controller,
          course: course,
          lesson: lesson,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = controller.selectedCourse!;
    final language = controller.interfaceLanguage;
    final nextLesson = course.lessons.firstWhere(
      (lesson) => !controller.isLessonCompleted(course, lesson),
      orElse: () => course.lessons.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${course.flag} ${course.nativeName}'),
        actions: [
          IconButton(
            tooltip: localized(language, pl: 'Zmień język', uk: 'Змінити мову'),
            onPressed: controller.clearCourseSelection,
            icon: const Icon(Icons.swap_horiz_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Color(course.colorValue),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localized(language, pl: 'Twój kurs', uk: 'Твій курс'),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  course.name.resolve(language),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: controller.courseCompletion(course),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  localized(
                    language,
                    pl: '${controller.completedLessons(course)} z ${course.lessons.length} lekcji ukończonych',
                    uk: '${controller.completedLessons(course)} із ${course.lessons.length} уроків завершено',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(course.colorValue),
                  ),
                  onPressed: () => _openLesson(context, course, nextLesson),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    localized(
                      language,
                      pl: 'Kontynuuj naukę',
                      uk: 'Продовжити навчання',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            localized(language, pl: 'Moduły kursu', uk: 'Модулі курсу'),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final module in course.modules) ...[
            _ModuleCard(
              controller: controller,
              course: course,
              module: module,
              onOpen: (lesson) => _openLesson(context, course, lesson),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.controller,
    required this.course,
    required this.module,
    required this.onOpen,
  });

  final AppController controller;
  final LanguageCourse course;
  final CourseModule module;
  final ValueChanged<CourseLesson> onOpen;

  @override
  Widget build(BuildContext context) {
    final language = controller.interfaceLanguage;
    final completed = module.lessons
        .where((lesson) => controller.isLessonCompleted(course, lesson))
        .length;
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.fromLTRB(18, 10, 14, 10),
        childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
        leading: CircleAvatar(child: Text(module.level)),
        title: Text(
          module.title.resolve(language),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${module.description.resolve(language)}\n$completed/${module.lessons.length}',
        ),
        children: [
          for (var index = 0; index < module.lessons.length; index++)
            ListTile(
              key: ValueKey('lesson-${course.id}-${module.lessons[index].id}'),
              leading: CircleAvatar(
                backgroundColor:
                    controller.isLessonCompleted(course, module.lessons[index])
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child:
                    controller.isLessonCompleted(course, module.lessons[index])
                    ? const Icon(Icons.check_rounded)
                    : Text('${index + 1}'),
              ),
              title: Text(module.lessons[index].title.resolve(language)),
              subtitle: Text(module.lessons[index].objective.resolve(language)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => onOpen(module.lessons[index]),
            ),
        ],
      ),
    );
  }
}
