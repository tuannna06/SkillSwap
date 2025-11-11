import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

void main() {
  group('CustomAppBar Widget Tests', () {
    testWidgets('displays the correct title', (WidgetTester tester) async {
      const titleText = 'Test AppBar';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(title: titleText),
          ),
        ),
      );

      //verify title is displayed
      expect(find.text(titleText), findsOneWidget);
    });

    testWidgets('displays leading widget if provided', (WidgetTester tester) async {
      const titleText = 'Test AppBar';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: titleText,
              leading: const Icon(Icons.menu),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays actions if provided', (WidgetTester tester) async {
      const titleText = 'Test AppBar';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: titleText,
              actions: const [
                Icon(Icons.search),
                Icon(Icons.settings),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor, elevation, and shadowColor', (WidgetTester tester) async {
      const titleText = 'Test AppBar';
      const customColor = Colors.blue;
      const customElevation = 5.0;
      const customShadowColor = Colors.black;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(
              title: titleText,
              backgroundColor: customColor,
              elevation: customElevation,
              shadowColor: customShadowColor,
            ),
          ),
        ),
      );

      final appBarFinder = find.byType(AppBar);
      final appBarWidget = tester.widget<AppBar>(appBarFinder);

      expect(appBarWidget.backgroundColor, customColor);
      expect(appBarWidget.elevation, customElevation);
      expect(appBarWidget.shadowColor, customShadowColor);
    });

    testWidgets('uses default values when optional parameters are not provided', (WidgetTester tester) async {
      const titleText = 'Test AppBar';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: CustomAppBar(title: titleText),
          ),
        ),
      );

      final appBarFinder = find.byType(AppBar);
      final appBarWidget = tester.widget<AppBar>(appBarFinder);

      expect(appBarWidget.backgroundColor, Colors.white);
      expect(appBarWidget.elevation, 2);
      expect(appBarWidget.shadowColor, Colors.grey[50]);
      expect(appBarWidget.leading, null);
      expect(appBarWidget.actions, null);
    });
  });
}
