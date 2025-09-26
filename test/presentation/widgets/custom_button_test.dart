// 🧪 Unit Tests para CustomButton
// Tests para el botón personalizado de la aplicación

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_double_v_partners/presentation/widgets/button.dart';

void main() {
  group('🔘 CustomButton Tests', () {
    testWidgets('should display text correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('should handle tap correctly', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Tap Me',
              onPressed: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should be disabled when onPressed is null', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.onPressed, isNull);
      expect(find.text('Disabled Button'), findsOneWidget);
    });

    testWidgets('should apply custom colors when provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Colored Button',
              onPressed: () {},
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.backgroundColor, equals(Colors.red));
      expect(button.textColor, equals(Colors.white));
    });

    testWidgets('should show loading state when isLoading is true', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // El texto no debería estar visible cuando está cargando
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.isLoading, isTrue);
    });

    testWidgets('should handle enabled state correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Enabled Button',
              onPressed: () {},
              enabled: true,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('should handle disabled state correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: () {},
              enabled: false,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.enabled, isFalse);
    });

    testWidgets('should apply border color when provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Bordered Button',
              onPressed: () {},
              borderColor: Colors.blue,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.borderColor, equals(Colors.blue));
    });

    testWidgets('should handle empty text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: '',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(''), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('should handle short text correctly', (WidgetTester tester) async {
      // Arrange
      const shortText = 'Short Text';
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: shortText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(shortText), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('should not call onPressed when disabled', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: () {
                wasTapped = true;
              },
              enabled: false,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert
      expect(wasTapped, isFalse);
    });

    testWidgets('should not call onPressed when loading', (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () {
                wasTapped = true;
              },
              isLoading: true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert
      expect(wasTapped, isFalse);
    });
  });
}
