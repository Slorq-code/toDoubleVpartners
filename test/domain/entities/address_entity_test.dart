// 🧪 Unit Tests para AddressEntity
// Tests exhaustivos para la entidad de dirección

import 'package:flutter_test/flutter_test.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';

void main() {
  group('🏠 AddressEntity Tests', () {
    // Test data
    late AddressEntity testAddressColombia;
    late AddressEntity testAddressInternational;

    setUp(() {
      testAddressColombia = const AddressEntity(
        id: 'addr_col_1',
        addressLine1: 'Calle 123 #45-67',
        addressLine2: 'Apartamento 301',
        country: 'Colombia',
        department: 'Bogotá D.C.',
        city: 'Bogotá',
        postalCode: '110111',
        isPrimary: true,
        isColombia: true,
      );

      testAddressInternational = const AddressEntity(
        id: 'addr_int_1',
        addressLine1: '123 Main Street',
        addressLine2: 'Apt 4B',
        country: 'United States',
        department: 'California',
        city: 'Los Angeles',
        postalCode: '90210',
        isPrimary: false,
        isColombia: false,
      );
    });

    group('🏗️ Constructor & Properties', () {
      test('should create address with required fields only', () {
        // Arrange & Act
        const address = AddressEntity(
          id: 'test_id',
          addressLine1: 'Test Street 123',
          country: 'Test Country',
          department: 'Test Department',
          city: 'Test City',
        );

        // Assert
        expect(address.id, equals('test_id'));
        expect(address.addressLine1, equals('Test Street 123'));
        expect(address.country, equals('Test Country'));
        expect(address.department, equals('Test Department'));
        expect(address.city, equals('Test City'));
        expect(address.addressLine2, isNull);
        expect(address.postalCode, isNull);
        expect(address.isPrimary, isFalse);
        expect(address.isColombia, isTrue); // Default value
      });

      test('should create Colombian address with all fields', () {
        // Assert
        expect(testAddressColombia.id, equals('addr_col_1'));
        expect(testAddressColombia.addressLine1, equals('Calle 123 #45-67'));
        expect(testAddressColombia.addressLine2, equals('Apartamento 301'));
        expect(testAddressColombia.country, equals('Colombia'));
        expect(testAddressColombia.department, equals('Bogotá D.C.'));
        expect(testAddressColombia.city, equals('Bogotá'));
        expect(testAddressColombia.postalCode, equals('110111'));
        expect(testAddressColombia.isPrimary, isTrue);
        expect(testAddressColombia.isColombia, isTrue);
      });

      test('should create international address with all fields', () {
        // Assert
        expect(testAddressInternational.id, equals('addr_int_1'));
        expect(testAddressInternational.addressLine1, equals('123 Main Street'));
        expect(testAddressInternational.addressLine2, equals('Apt 4B'));
        expect(testAddressInternational.country, equals('United States'));
        expect(testAddressInternational.department, equals('California'));
        expect(testAddressInternational.city, equals('Los Angeles'));
        expect(testAddressInternational.postalCode, equals('90210'));
        expect(testAddressInternational.isPrimary, isFalse);
        expect(testAddressInternational.isColombia, isFalse);
      });
    });

    group('🔄 CopyWith Method', () {
      test('should create copy with updated id', () {
        // Act
        final updatedAddress = testAddressColombia.copyWith(id: 'new_id');

        // Assert
        expect(updatedAddress.id, equals('new_id'));
        expect(updatedAddress.addressLine1, equals(testAddressColombia.addressLine1));
        expect(updatedAddress.country, equals(testAddressColombia.country));
        expect(updatedAddress.department, equals(testAddressColombia.department));
        expect(updatedAddress.city, equals(testAddressColombia.city));
      });

      test('should create copy with updated addressLine1', () {
        // Act
        final updatedAddress = testAddressColombia.copyWith(
          addressLine1: 'Nueva Calle 456 #78-90',
        );

        // Assert
        expect(updatedAddress.addressLine1, equals('Nueva Calle 456 #78-90'));
        expect(updatedAddress.id, equals(testAddressColombia.id));
        expect(updatedAddress.country, equals(testAddressColombia.country));
      });

      test('should create copy with updated city and department', () {
        // Act
        final updatedAddress = testAddressColombia.copyWith(
          city: 'Medellín',
          department: 'Antioquia',
        );

        // Assert
        expect(updatedAddress.city, equals('Medellín'));
        expect(updatedAddress.department, equals('Antioquia'));
        expect(updatedAddress.addressLine1, equals(testAddressColombia.addressLine1));
      });

      test('should create copy with updated isPrimary', () {
        // Act
        final updatedAddress = testAddressColombia.copyWith(isPrimary: false);

        // Assert
        expect(updatedAddress.isPrimary, isFalse);
        expect(updatedAddress.id, equals(testAddressColombia.id));
      });

      test('should create copy with updated isColombia', () {
        // Act
        final updatedAddress = testAddressColombia.copyWith(isColombia: false);

        // Assert
        expect(updatedAddress.isColombia, isFalse);
        expect(updatedAddress.country, equals(testAddressColombia.country));
      });

      test('should create copy without changing original', () {
        // Arrange
        final originalId = testAddressColombia.id;
        final originalCity = testAddressColombia.city;

        // Act
        final updatedAddress = testAddressColombia.copyWith(
          id: 'new_id',
          city: 'Nueva Ciudad',
        );

        // Assert - Original no cambió
        expect(testAddressColombia.id, equals(originalId));
        expect(testAddressColombia.city, equals(originalCity));
        
        // Assert - Copia sí cambió
        expect(updatedAddress.id, equals('new_id'));
        expect(updatedAddress.city, equals('Nueva Ciudad'));
      });
    });

    group('📝 FormattedAddress Property', () {
      test('should format Colombian address correctly with all fields', () {
        // Act
        final formatted = testAddressColombia.formattedAddress;

        // Assert
        expect(formatted, contains('Calle 123 #45-67'));
        expect(formatted, contains('Complemento: Apartamento 301'));
        expect(formatted, contains('Bogotá, Bogotá D.C.'));
        expect(formatted, contains('Colombia'));
        expect(formatted, contains('Código postal: 110111'));
        
        // Verificar orden de las líneas
        final lines = formatted.split('\n');
        expect(lines[0], equals('Calle 123 #45-67'));
        expect(lines[1], equals('Complemento: Apartamento 301'));
        expect(lines[2], equals('Bogotá, Bogotá D.C.'));
        expect(lines[3], equals('Colombia'));
        expect(lines[4], equals('Código postal: 110111'));
      });

      test('should format international address correctly', () {
        // Act
        final formatted = testAddressInternational.formattedAddress;

        // Assert
        expect(formatted, contains('123 Main Street'));
        expect(formatted, contains('Complemento: Apt 4B'));
        expect(formatted, contains('Los Angeles, California'));
        expect(formatted, contains('United States'));
        expect(formatted, contains('Código postal: 90210'));
      });

      test('should format address without optional fields', () {
        // Arrange
        const address = AddressEntity(
          id: 'simple_addr',
          addressLine1: 'Simple Street 123',
          country: 'Test Country',
          department: 'Test Department',
          city: 'Test City',
        );

        // Act
        final formatted = address.formattedAddress;

        // Assert
        expect(formatted, contains('Simple Street 123'));
        expect(formatted, contains('Test City, Test Department'));
        expect(formatted, contains('Test Country'));
        expect(formatted, isNot(contains('Complemento:')));
        expect(formatted, isNot(contains('Código postal:')));
        
        // Verificar que solo tiene 3 líneas
        final lines = formatted.split('\n');
        expect(lines, hasLength(3));
      });

      test('should handle empty addressLine2', () {
        // Arrange
        final address = testAddressColombia.copyWith(addressLine2: '');

        // Act
        final formatted = address.formattedAddress;

        // Assert
        expect(formatted, isNot(contains('Complemento:')));
        expect(formatted, contains('Calle 123 #45-67'));
        expect(formatted, contains('Bogotá, Bogotá D.C.'));
      });

      test('should handle empty postalCode', () {
        // Arrange
        final address = testAddressColombia.copyWith(postalCode: '');

        // Act
        final formatted = address.formattedAddress;

        // Assert
        expect(formatted, isNot(contains('Código postal:')));
        expect(formatted, contains('Calle 123 #45-67'));
        expect(formatted, contains('Colombia'));
      });

      test('should handle null addressLine2 and postalCode', () {
        // Arrange - Crear una nueva dirección sin addressLine2 ni postalCode
        const address = AddressEntity(
          id: 'test_addr',
          addressLine1: 'Calle 123 #45-67',
          country: 'Colombia',
          department: 'Bogotá D.C.',
          city: 'Bogotá',
          // addressLine2 y postalCode son null por defecto
        );

        // Act
        final formatted = address.formattedAddress;

        // Assert
        expect(formatted, isNot(contains('Complemento:')));
        expect(formatted, isNot(contains('Código postal:')));
        
        final lines = formatted.split('\n');
        expect(lines, hasLength(3));
        expect(lines[0], equals('Calle 123 #45-67'));
        expect(lines[1], equals('Bogotá, Bogotá D.C.'));
        expect(lines[2], equals('Colombia'));
      });
    });

    group('🗺️ Serialization', () {
      test('toMap should convert address to Map correctly', () {
        // Act
        final map = testAddressColombia.toMap();

        // Assert
        expect(map['id'], equals('addr_col_1'));
        expect(map['addressLine1'], equals('Calle 123 #45-67'));
        expect(map['addressLine2'], equals('Apartamento 301'));
        expect(map['country'], equals('Colombia'));
        expect(map['department'], equals('Bogotá D.C.'));
        expect(map['city'], equals('Bogotá'));
        expect(map['isColombia'], isTrue);
        
        // Verificar que NO incluye postalCode ni isPrimary según comentario en código
        expect(map, isNot(contains('postalCode')));
        expect(map, isNot(contains('isPrimary')));
      });

      test('toMap should handle null addressLine2', () {
        // Arrange - Crear dirección sin addressLine2
        const address = AddressEntity(
          id: 'test_addr',
          addressLine1: 'Calle 123 #45-67',
          country: 'Colombia',
          department: 'Bogotá D.C.',
          city: 'Bogotá',
          // addressLine2 es null por defecto
        );

        // Act
        final map = address.toMap();

        // Assert
        expect(map['addressLine2'], isNull);
        expect(map['addressLine1'], equals('Calle 123 #45-67'));
      });

      test('fromMap should create address from Map correctly', () {
        // Arrange
        final map = {
          'id': 'addr_from_map',
          'addressLine1': 'Mapped Street 789',
          'addressLine2': 'Floor 2',
          'country': 'Colombia',
          'department': 'Valle del Cauca',
          'city': 'Cali',
          'postalCode': '760001',
          'isPrimary': true,
          'isColombia': true,
        };

        // Act
        final address = AddressEntity.fromMap(map);

        // Assert
        expect(address.id, equals('addr_from_map'));
        expect(address.addressLine1, equals('Mapped Street 789'));
        expect(address.addressLine2, equals('Floor 2'));
        expect(address.country, equals('Colombia'));
        expect(address.department, equals('Valle del Cauca'));
        expect(address.city, equals('Cali'));
        expect(address.postalCode, equals('760001'));
        expect(address.isPrimary, isTrue);
        expect(address.isColombia, isTrue);
      });

      test('fromMap should handle missing optional fields', () {
        // Arrange
        final map = {
          'id': 'addr_minimal',
          'addressLine1': 'Minimal Street',
          'country': 'Test Country',
          'department': 'Test Department',
          'city': 'Test City',
        };

        // Act
        final address = AddressEntity.fromMap(map);

        // Assert
        expect(address.id, equals('addr_minimal'));
        expect(address.addressLine1, equals('Minimal Street'));
        expect(address.addressLine2, isNull);
        expect(address.postalCode, isNull);
        expect(address.isPrimary, isFalse); // Default value
        expect(address.isColombia, isTrue); // Default value
      });

      test('fromMap should handle empty strings', () {
        // Arrange
        final map = {
          'id': '',
          'addressLine1': '',
          'country': '',
          'department': '',
          'city': '',
        };

        // Act
        final address = AddressEntity.fromMap(map);

        // Assert
        expect(address.id, equals(''));
        expect(address.addressLine1, equals(''));
        expect(address.country, equals(''));
        expect(address.department, equals(''));
        expect(address.city, equals(''));
      });
    });

    group('🔍 toString Method', () {
      test('toString should return formatted string', () {
        // Act
        final result = testAddressColombia.toString();

        // Assert
        expect(result, contains('AddressEntity'));
        expect(result, contains('addr_col_1'));
        expect(result, contains('Calle 123 #45-67'));
        expect(result, contains('Bogotá'));
        expect(result, contains('Colombia'));
      });

      test('toString should handle international address', () {
        // Act
        final result = testAddressInternational.toString();

        // Assert
        expect(result, contains('AddressEntity'));
        expect(result, contains('addr_int_1'));
        expect(result, contains('123 Main Street'));
        expect(result, contains('Los Angeles'));
        expect(result, contains('United States'));
      });
    });

    group('⚖️ Equality & Comparison', () {
      test('addresses with same data should have equal properties', () {
        // Arrange
        const address1 = AddressEntity(
          id: 'same_id',
          addressLine1: 'Same Street',
          country: 'Same Country',
          department: 'Same Department',
          city: 'Same City',
        );
        
        const address2 = AddressEntity(
          id: 'same_id',
          addressLine1: 'Same Street',
          country: 'Same Country',
          department: 'Same Department',
          city: 'Same City',
        );

        // Act & Assert
        expect(address1.id, equals(address2.id));
        expect(address1.addressLine1, equals(address2.addressLine1));
        expect(address1.country, equals(address2.country));
        expect(address1.department, equals(address2.department));
        expect(address1.city, equals(address2.city));
        expect(address1.isColombia, equals(address2.isColombia));
        expect(address1.isPrimary, equals(address2.isPrimary));
      });

      test('should differentiate Colombian vs International addresses', () {
        // Assert
        expect(testAddressColombia.isColombia, isTrue);
        expect(testAddressInternational.isColombia, isFalse);
        expect(testAddressColombia.country, equals('Colombia'));
        expect(testAddressInternational.country, equals('United States'));
      });

      test('should differentiate primary vs secondary addresses', () {
        // Assert
        expect(testAddressColombia.isPrimary, isTrue);
        expect(testAddressInternational.isPrimary, isFalse);
      });
    });

    group('🔧 Edge Cases', () {
      test('should handle very long address lines', () {
        // Arrange
        const longAddress = 'This is a very long address line that might be used in some cases where the address is extremely detailed and contains a lot of information about the location';
        
        const address = AddressEntity(
          id: 'long_addr',
          addressLine1: longAddress,
          country: 'Test Country',
          department: 'Test Department',
          city: 'Test City',
        );

        // Act & Assert
        expect(address.addressLine1, equals(longAddress));
        expect(address.formattedAddress, contains(longAddress));
      });

      test('should handle special characters in address', () {
        // Arrange
        const address = AddressEntity(
          id: 'special_addr',
          addressLine1: 'Calle 123 #45-67 Apto 301-A',
          addressLine2: 'Edificio "Los Andes" - Torre B',
          country: 'Colombia',
          department: 'Bogotá D.C.',
          city: 'Bogotá',
        );

        // Act & Assert
        expect(address.addressLine1, contains('#'));
        expect(address.addressLine1, contains('-'));
        expect(address.addressLine2, contains('"'));
        expect(address.addressLine2, contains('-'));
        expect(address.formattedAddress, contains('Edificio "Los Andes"'));
      });

      test('should handle unicode characters', () {
        // Arrange
        const address = AddressEntity(
          id: 'unicode_addr',
          addressLine1: 'Calle de la Niñez #123',
          country: 'España',
          department: 'Cataluña',
          city: 'Barcelona',
        );

        // Act & Assert
        expect(address.addressLine1, contains('ñ'));
        expect(address.country, contains('ñ'));
        expect(address.department, contains('ñ'));
        expect(address.formattedAddress, contains('Niñez'));
      });
    });
  });
}
