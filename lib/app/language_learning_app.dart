import 'package:flutter/material.dart';

import '../screens/course_picker_screen.dart';
import '../screens/home_shell.dart';
import '../state/app_controller.dart';
import '../theme/app_theme.dart';

class LanguageLearningApp extends StatelessWidget {
  const LanguageLearningApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Języki Krok po Kroku',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: controller.themeMode,
      home: controller.selectedCourse == null
          ? CoursePickerScreen(controller: controller)
          : HomeShell(controller: controller),
    ),
  );
}
