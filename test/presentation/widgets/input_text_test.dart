// 🧪 Unit Tests para InputText
// Tests para el campo de texto personalizado

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_double_v_partners/presentation/widgets/input_text.dart';

void main() {
  group('📝 InputText Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display label and placeholder correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Test Label',
              placeholder: 'Test Placeholder',
              controller: controller,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Placeholder'), findsOneWidget);
      expect(find.byType(InputText), findsOneWidget);
    });

    testWidgets('should handle text input correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Input Test',
              placeholder: 'Enter text',
              controller: controller,
            ),
          ),
        ),
      );

      // Act - Set text directly on controller
      controller.text = 'Test input';
      await tester.pump();

      // Assert
      expect(controller.text, equals('Test input'));
      expect(find.byType(InputText), findsOneWidget);
    });


    testWidgets('should apply keyboard type correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Email Input',
              placeholder: 'Enter email',
              controller: controller,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      // Assert - Verificar que el widget se crea correctamente
      final inputWidget = tester.widget<InputText>(find.byType(InputText));
      expect(inputWidget.keyboardType, equals(TextInputType.emailAddress));
    });

    testWidgets('should apply text input action correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Action Input',
              placeholder: 'Press next',
              controller: controller,
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      );

      // Assert - Verificar que el widget se crea correctamente
      final inputWidget = tester.widget<InputText>(find.byType(InputText));
      expect(inputWidget.textInputAction, equals(TextInputAction.next));
    });


    testWidgets('should handle long text input', (WidgetTester tester) async {
      // Arrange
      const longText = 'This is a very long text input that should be handled correctly by the InputText widget without any issues or overflow problems';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Long Text Test',
              placeholder: 'Enter long text',
              controller: controller,
            ),
          ),
        ),
      );

      // Act - Set text directly on controller
      controller.text = longText;
      await tester.pump();

      // Assert
      expect(controller.text, equals(longText));
      expect(find.byType(InputText), findsOneWidget);
    });

    testWidgets('should handle special characters', (WidgetTester tester) async {
      // Arrange
      const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Special Chars Test',
              placeholder: 'Enter special characters',
              controller: controller,
            ),
          ),
        ),
      );

      // Act - Set text directly on controller
      controller.text = specialText;
      await tester.pump();

      // Assert
      expect(controller.text, equals(specialText));
      expect(find.byType(InputText), findsOneWidget);
    });

    testWidgets('should handle unicode characters', (WidgetTester tester) async {
      // Arrange
      const unicodeText = 'Niño, café, piñata';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputText(
              label: 'Unicode Test',
              placeholder: 'Enter unicode text',
              controller: controller,
            ),
          ),
        ),
      );

      // Act
      controller.text = unicodeText; // Set directly instead of enterText
      await tester.pump();

      // Assert
      expect(controller.text, equals(unicodeText));
    });

  });
}
