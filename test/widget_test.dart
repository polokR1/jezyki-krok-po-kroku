import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jezyki_krok_po_kroku/app/language_learning_app.dart';
import 'package:jezyki_krok_po_kroku/data/course_registry.dart';
import 'package:jezyki_krok_po_kroku/domain/models/course.dart';
import 'package:jezyki_krok_po_kroku/screens/lesson_screen.dart';
import 'package:jezyki_krok_po_kroku/state/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('first launch offers all four courses', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();

    await tester.pumpWidget(LanguageLearningApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Języki Krok po Kroku'), findsOneWidget);
    expect(find.text('Angielski'), findsOneWidget);
    expect(find.text('Hiszpański'), findsOneWidget);
    expect(find.text('Grecki'), findsOneWidget);
    expect(find.text('Szwedzki'), findsOneWidget);
    expect(find.text('Opanowane 0/640'), findsNWidgets(4));
  });

  testWidgets('practice hub exposes grammar dialogues and stories', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();
    await tester.pumpWidget(LanguageLearningApp(controller: controller));
    await tester.tap(find.byKey(const ValueKey('course-english')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Praktyka'));
    await tester.pumpAndSettle();

    expect(find.text('Gramatyka'), findsOneWidget);
    expect(find.text('Dialogi'), findsOneWidget);
    expect(find.text('Historie'), findsOneWidget);
    expect(find.text('152 aktywności w pełnym kursie'), findsOneWidget);
  });

  testWidgets('beginner sentence production uses tappable word tiles', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();
    final course = courses.firstWhere((candidate) => candidate.id == 'english');
    final lesson = CourseLesson(
      id: 'tile_test',
      title: const LocalizedText(pl: 'Kafelki', uk: 'Плитки'),
      objective: const LocalizedText(pl: 'Ułóż zdanie', uk: 'Склади речення'),
      items: const [
        LearningItem(
          id: 'tile_item',
          target: 'Good morning',
          translation: LocalizedText(pl: 'dzień dobry', uk: 'добрий день'),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LessonScreen(
          controller: controller,
          course: course,
          lesson: lesson,
        ),
      ),
    );
    await tester.tap(find.text('Zacznij krok po kroku'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Przejdź do ćwiczeń'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('dzień dobry'));
    await tester.pump();
    await tester.tap(find.text('Sprawdź'));
    await tester.pump();
    await tester.tap(find.text('Dalej'));
    await tester.pumpAndSettle();

    expect(find.text('Dostępne słowa'), findsOneWidget);
    expect(find.text('Twoje zdanie'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Good'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'morning'), findsOneWidget);
  });

  testWidgets('selecting a course opens its independent learning path', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();

    await tester.pumpWidget(LanguageLearningApp(controller: controller));
    await tester.tap(find.byKey(const ValueKey('course-english')));
    await tester.pumpAndSettle();

    expect(controller.selectedCourse?.id, 'english');
    expect(find.textContaining('English'), findsOneWidget);
    expect(find.text('Ścieżka krok po kroku'), findsOneWidget);
    expect(find.text('Kontynuuj naukę'), findsOneWidget);
  });

  testWidgets('interface language can be changed before course selection', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await AppController.create();

    await tester.pumpWidget(LanguageLearningApp(controller: controller));
    await tester.tap(find.text('UA'));
    await tester.pumpAndSettle();

    expect(controller.interfaceLanguage, 'uk');
    expect(find.text('Мови крок за кроком'), findsOneWidget);
    expect(find.text('Англійська'), findsOneWidget);
  });
}
