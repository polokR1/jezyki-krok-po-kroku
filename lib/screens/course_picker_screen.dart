import 'package:flutter/material.dart';

import '../data/course_registry.dart';
import '../l10n/app_localization.dart';
import '../state/app_controller.dart';

class CoursePickerScreen extends StatelessWidget {
  const CoursePickerScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final language = controller.interfaceLanguage;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.translate_rounded, size: 30),
                        ),
                        const Spacer(),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'pl', label: Text('PL')),
                            ButtonSegment(value: 'uk', label: Text('UA')),
                          ],
                          selected: {language},
                          onSelectionChanged: (value) =>
                              controller.setInterfaceLanguage(value.first),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      localized(
                        language,
                        pl: 'Języki Krok po Kroku',
                        uk: 'Мови крок за кроком',
                      ),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localized(
                        language,
                        pl: 'Wybierz język, którego chcesz się uczyć. Postęp każdego kursu zapisujemy osobno.',
                        uk: 'Обери мову, яку хочеш вивчати. Прогрес кожного курсу зберігається окремо.',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (controller.storageWarning != null) ...[
                      const SizedBox(height: 16),
                      _WarningCard(message: controller.storageWarning!),
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.56,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final course = courses[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: ValueKey('course-${course.id}'),
                      onTap: () => controller.selectCourse(course.id),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.flag,
                              style: const TextStyle(fontSize: 42),
                            ),
                            const Spacer(),
                            Text(
                              course.name.resolve(language),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(course.nativeName),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: course.items.isEmpty
                                  ? 0
                                  : controller.masteredItems(course) /
                                        course.items.length,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              localized(
                                language,
                                pl: 'Opanowane ${controller.masteredItems(course)}/${course.items.length}',
                                uk: 'Засвоєно ${controller.masteredItems(course)}/${course.items.length}',
                              ),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              localized(
                                language,
                                pl: '${course.modules.length} moduły · ${course.activityCount} lekcji',
                                uk: '${course.modules.length} модулі · ${course.activityCount} уроків',
                              ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: courses.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.errorContainer,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}
