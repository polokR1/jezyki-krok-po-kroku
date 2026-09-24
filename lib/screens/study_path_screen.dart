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

  void _openReview(BuildContext context, LanguageCourse course) {
    final progress = controller.progressFor(course.id);
    final due = course.items.where((item) => progress.isDue(item.id)).toList();
    final candidates = due.isNotEmpty
        ? due
        : course.items
              .where((item) => !progress.masteredItems.contains(item.id))
              .toList();
    candidates.sort(
      (a, b) => (progress.itemStrength[a.id] ?? 0).compareTo(
        progress.itemStrength[b.id] ?? 0,
      ),
    );
    final items = candidates.take(5).toList(growable: false);
    if (items.isEmpty) return;
    _openLesson(
      context,
      course,
      CourseLesson(
        id: '${course.id}_review',
        title: LocalizedText(
          pl: due.isNotEmpty ? 'Zaplanowana powtórka' : 'Trening słówek',
          uk: due.isNotEmpty ? 'Заплановане повторення' : 'Тренування слів',
        ),
        objective: LocalizedText(
          pl: 'Utrwal ${items.length} najsłabszych wyrażeń',
          uk: 'Закріпи ${items.length} найслабших висловів',
        ),
        items: items,
        minutes: 8,
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
                    pl: '${controller.completedActivities(course)} z ${course.activityCount} aktywności ukończonych',
                    uk: '${controller.completedActivities(course)} із ${course.activityCount} активностей завершено',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _CounterBadge(
                      icon: Icons.auto_awesome_rounded,
                      text: localized(
                        language,
                        pl: 'Opanowane ${controller.masteredItems(course)}/${course.items.length}',
                        uk: 'Засвоєно ${controller.masteredItems(course)}/${course.items.length}',
                      ),
                    ),
                    _CounterBadge(
                      icon: Icons.event_repeat_rounded,
                      text: localized(
                        language,
                        pl: 'Powtórki ${controller.dueReviews(course)}',
                        uk: 'Повторення ${controller.dueReviews(course)}',
                      ),
                    ),
                  ],
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
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                  ),
                  onPressed: () => _openReview(context, course),
                  icon: const Icon(Icons.event_repeat_rounded),
                  label: Text(
                    localized(
                      language,
                      pl: controller.dueReviews(course) > 0
                          ? 'Wykonaj powtórkę (${controller.dueReviews(course)})'
                          : 'Trening słówek',
                      uk: controller.dueReviews(course) > 0
                          ? 'Виконати повторення (${controller.dueReviews(course)})'
                          : 'Тренування слів',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            localized(
              language,
              pl: 'Ścieżka krok po kroku',
              uk: 'Шлях крок за кроком',
            ),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (
            var moduleIndex = 0;
            moduleIndex < course.modules.length;
            moduleIndex++
          ) ...[
            _ModuleCard(
              controller: controller,
              course: course,
              module: course.modules[moduleIndex],
              moduleIndex: moduleIndex,
              onOpen: (lesson) => _openLesson(context, course, lesson),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.controller,
    required this.course,
    required this.module,
    required this.moduleIndex,
    required this.onOpen,
  });

  final AppController controller;
  final LanguageCourse course;
  final CourseModule module;
  final int moduleIndex;
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
          '${localized(language, pl: 'Etap', uk: 'Етап')} ${moduleIndex + 1}. ${module.title.resolve(language)}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${module.description.resolve(language)}\n$completed/${module.lessons.length}',
        ),
        children: [
          for (var index = 0; index < module.lessons.length; index++)
            Builder(
              builder: (context) {
                final lesson = module.lessons[index];
                final completed = controller.isLessonCompleted(course, lesson);
                return ListTile(
                  key: ValueKey(
                    'lesson-${course.id}-${module.lessons[index].id}',
                  ),
                  leading: CircleAvatar(
                    backgroundColor: completed
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: completed
                        ? const Icon(Icons.check_rounded)
                        : Text('${index + 1}'),
                  ),
                  title: Text(lesson.title.resolve(language)),
                  subtitle: Text(lesson.objective.resolve(language)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onOpen(lesson),
                );
              },
            ),
        ],
      ),
    );
  }
}
