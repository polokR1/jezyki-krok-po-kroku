import 'package:flutter/material.dart';

import '../l10n/app_localization.dart';
import '../state/app_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final language = controller.interfaceLanguage;
    final course = controller.selectedCourse!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localized(language, pl: 'Ustawienia', uk: 'Налаштування')),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          _SectionTitle(localized(language, pl: 'Kurs', uk: 'Курс')),
          Card(
            child: ListTile(
              leading: Text(course.flag, style: const TextStyle(fontSize: 30)),
              title: Text(course.name.resolve(language)),
              subtitle: Text(course.nativeName),
              trailing: const Icon(Icons.swap_horiz_rounded),
              onTap: controller.clearCourseSelection,
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            localized(language, pl: 'Język objaśnień', uk: 'Мова пояснень'),
          ),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'pl', label: Text('Polski')),
              ButtonSegment(value: 'uk', label: Text('Українська')),
            ],
            selected: {language},
            onSelectionChanged: (value) =>
                controller.setInterfaceLanguage(value.first),
          ),
          const SizedBox(height: 24),
          _SectionTitle(
            localized(language, pl: 'Plan nauki', uk: 'План навчання'),
          ),
          DropdownButtonFormField<int>(
            initialValue: controller.dailyGoalMinutes,
            decoration: InputDecoration(
              labelText: localized(
                language,
                pl: 'Dzienny cel',
                uk: 'Щоденна мета',
              ),
            ),
            items: [
              for (final minutes in const [5, 10, 15, 20, 30])
                DropdownMenuItem(value: minutes, child: Text('$minutes min')),
            ],
            onChanged: (value) {
              if (value != null) controller.setDailyGoalMinutes(value);
            },
          ),
          const SizedBox(height: 24),
          _SectionTitle(localized(language, pl: 'Wygląd', uk: 'Вигляд')),
          DropdownButtonFormField<String>(
            initialValue: controller.themePreference,
            decoration: InputDecoration(
              labelText: localized(language, pl: 'Motyw', uk: 'Тема'),
            ),
            items: [
              DropdownMenuItem(
                value: 'system',
                child: Text(
                  localized(language, pl: 'Systemowy', uk: 'Системна'),
                ),
              ),
              DropdownMenuItem(
                value: 'light',
                child: Text(localized(language, pl: 'Jasny', uk: 'Світла')),
              ),
              DropdownMenuItem(
                value: 'dark',
                child: Text(localized(language, pl: 'Ciemny', uk: 'Темна')),
              ),
            ],
            onChanged: (value) {
              if (value != null) controller.setThemePreference(value);
            },
          ),
          const SizedBox(height: 24),
          _SectionTitle(localized(language, pl: 'Wymowa', uk: 'Вимова')),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localized(
                      language,
                      pl: 'Tempo głosu',
                      uk: 'Швидкість голосу',
                    ),
                  ),
                  Slider(
                    value: controller.speechRate,
                    min: 0.25,
                    max: 0.6,
                    divisions: 7,
                    label: controller.speechRate.toStringAsFixed(2),
                    onChanged: controller.setSpeechRate,
                  ),
                ],
              ),
            ),
          ),
          if (controller.storageWarning != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(controller.storageWarning!),
              ),
            ),
          ],
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: () => _confirmReset(context),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(
              localized(
                language,
                pl: 'Wyzeruj postęp tego kursu',
                uk: 'Скинути прогрес цього курсу',
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            localized(
              language,
              pl: 'Języki Krok po Kroku · nowy silnik wielokursowy',
              uk: 'Мови крок за кроком · новий багатокурсовий рушій',
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final language = controller.interfaceLanguage;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localized(language, pl: 'Wyzerować postęp?', uk: 'Скинути прогрес?'),
        ),
        content: Text(
          localized(
            language,
            pl: 'Usunięte zostaną wyniki tylko aktualnego kursu. Inne kursy pozostaną bez zmian.',
            uk: 'Буде видалено результати лише поточного курсу. Інші курси не зміняться.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localized(language, pl: 'Anuluj', uk: 'Скасувати')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localized(language, pl: 'Wyzeruj', uk: 'Скинути')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.resetCourse(controller.selectedCourse!.id);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    ),
  );
}
