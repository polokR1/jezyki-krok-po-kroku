import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jezyki_krok_po_kroku/app/language_learning_app.dart';
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
    expect(find.text('Moduły kursu'), findsOneWidget);
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
