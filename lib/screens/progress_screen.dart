import 'package:flutter/material.dart';

import '../l10n/app_localization.dart';
import '../state/app_controller.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final course = controller.selectedCourse!;
    final progress = controller.progressFor(course.id);
    final language = controller.interfaceLanguage;
    final percent = (controller.courseCompletion(course) * 100).round();
    return Scaffold(
      appBar: AppBar(
        title: Text(localized(language, pl: 'Twój postęp', uk: 'Твій прогрес')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(course.flag, style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 8),
                  Text(
                    course.name.resolve(language),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: controller.courseCompletion(course),
                            strokeWidth: 12,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_outline_rounded,
                  value:
                      '${controller.completedActivities(course)}/${course.activityCount}',
                  label: localized(
                    language,
                    pl: 'Aktywności',
                    uk: 'Активності',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.auto_awesome_rounded,
                  value:
                      '${controller.masteredItems(course)}/${course.items.length}',
                  label: localized(language, pl: 'Opanowane', uk: 'Засвоєно'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.schedule_rounded,
            value: '${progress.minutesStudied} min',
            label: localized(language, pl: 'Czas nauki', uk: 'Час навчання'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  value: '${progress.streak}',
                  label: localized(language, pl: 'Seria dni', uk: 'Серія днів'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.track_changes_rounded,
                  value: '${progress.accuracy}%',
                  label: localized(language, pl: 'Skuteczność', uk: 'Точність'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.event_repeat_rounded,
            value: '${controller.dueReviews(course)}',
            label: localized(
              language,
              pl: 'Wyrażenia do powtórki',
              uk: 'Вислови для повторення',
            ),
          ),
          const SizedBox(height: 22),
          Text(
            localized(language, pl: 'Wyniki lekcji', uk: 'Результати уроків'),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          for (final lesson in course.lessons)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: Icon(
                progress.completedLessons.contains(lesson.id)
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              title: Text(lesson.title.resolve(language)),
              trailing: Text(
                progress.bestScores.containsKey(lesson.id)
                    ? '${progress.bestScores[lesson.id]}%'
                    : '—',
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    ),
  );
}
