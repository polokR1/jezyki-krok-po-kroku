import 'package:flutter/material.dart';

import '../l10n/app_localization.dart';
import '../state/app_controller.dart';
import 'progress_screen.dart';
import 'practice_hub_screen.dart';
import 'settings_screen.dart';
import 'study_path_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});
  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final language = widget.controller.interfaceLanguage;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          StudyPathScreen(controller: widget.controller),
          PracticeHubScreen(controller: widget.controller),
          ProgressScreen(controller: widget.controller),
          SettingsScreen(controller: widget.controller),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.route_outlined),
            selectedIcon: const Icon(Icons.route_rounded),
            label: localized(language, pl: 'Nauka', uk: 'Навчання'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center_rounded),
            label: localized(language, pl: 'Praktyka', uk: 'Практика'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights_rounded),
            label: localized(language, pl: 'Postęp', uk: 'Прогрес'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.tune_outlined),
            selectedIcon: const Icon(Icons.tune_rounded),
            label: localized(language, pl: 'Ustawienia', uk: 'Налаштування'),
          ),
        ],
      ),
    );
  }
}
