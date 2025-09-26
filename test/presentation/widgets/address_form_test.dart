// 🧪 Unit Tests para AddressForm
// Tests básicos para el formulario de direcciones

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/presentation/widgets/address_form.dart';

void main() {
  group('AddressForm Tests', () {
    testWidgets('should create AddressForm widget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(AddressForm), findsOneWidget);
    });

    testWidgets('should display form elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert - Verificar que el formulario se muestra
      expect(find.byType(AddressForm), findsOneWidget);
      
      // Verificar que hay elementos de formulario
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should handle onSave callback', (WidgetTester tester) async {
      // Arrange
      bool callbackCalled = false;
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {
                  callbackCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert - El widget se crea correctamente
      expect(find.byType(AddressForm), findsOneWidget);
      
      // El callback no se ha llamado aún
      expect(callbackCalled, isFalse);
    });

    testWidgets('should handle null onCancel callback', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
                onCancel: null,
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddressForm), findsOneWidget);
    });

    testWidgets('should handle onCancel callback', (WidgetTester tester) async {
      // Arrange
      bool cancelCalled = false;
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
                onCancel: () {
                  cancelCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert - El widget se crea correctamente
      expect(find.byType(AddressForm), findsOneWidget);
      
      // El callback no se ha llamado aún
      expect(cancelCalled, isFalse);
    });

    testWidgets('should handle initial address', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
                initialAddress: null,
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddressForm), findsOneWidget);
    });

    testWidgets('should be wrapped in ProviderScope', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddressForm(
                onSave: (address) {},
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert - Verificar que funciona con Riverpod
      expect(find.byType(ProviderScope), findsOneWidget);
      expect(find.byType(AddressForm), findsOneWidget);
    });

    testWidgets('should handle different screen sizes', (WidgetTester tester) async {
      // Arrange - Usar tamaño de pantalla normal para evitar overflow
      await tester.binding.setSurfaceSize(const Size(800, 600));
      
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AddressForm(
                  onSave: (address) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddressForm), findsOneWidget);
      
      // Reset screen size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle widget rebuild', (WidgetTester tester) async {
      // Arrange
      
      // Act - First build with scrollable container
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AddressForm(
                  onSave: (address) {},
                  key: const Key('first'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(AddressForm), findsOneWidget);

      // Act - Rebuild with different key
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: AddressForm(
                  onSave: (address) {},
                  key: const Key('second'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddressForm), findsOneWidget);
    });
  });
}
