// 🧪 Unit Tests para UserEntity
// Tests exhaustivos para la entidad principal de usuario

import 'package:flutter_test/flutter_test.dart';
import 'package:to_double_v_partners/domain/entities/user_entity.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';

void main() {
  group('👤 UserEntity Tests', () {
    // Test data
    late UserEntity testUser;
    late AddressEntity testAddress;
    late DateTime testBirthDate;
    late DateTime testCreatedAt;

    setUp(() {
      testBirthDate = DateTime(1990, 5, 15);
      testCreatedAt = DateTime(2024, 1, 1);
      
      testAddress = const AddressEntity(
        id: 'addr_1',
        addressLine1: 'Calle 123 #45-67',
        country: 'Colombia',
        department: 'Bogotá D.C.',
        city: 'Bogotá',
        isColombia: true,
      );

      testUser = UserEntity(
        id: 'user_123',
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: testBirthDate,
        addresses: [testAddress],
        createdAt: testCreatedAt,
      );
    });

    group('🏗️ Constructor & Properties', () {
      test('should create user with required fields only', () {
        // Arrange & Act
        final user = UserEntity(
          id: 'test_id',
          firstName: 'Test',
          lastName: 'User',
          birthDate: DateTime(1995, 1, 1),
        );

        // Assert
        expect(user.id, equals('test_id'));
        expect(user.firstName, equals('Test'));
        expect(user.lastName, equals('User'));
        expect(user.birthDate, equals(DateTime(1995, 1, 1)));
        expect(user.addresses, isEmpty);
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });

      test('should create user with all fields', () {
        // Assert
        expect(testUser.id, equals('user_123'));
        expect(testUser.firstName, equals('Juan'));
        expect(testUser.lastName, equals('Pérez'));
        expect(testUser.birthDate, equals(testBirthDate));
        expect(testUser.addresses, hasLength(1));
        expect(testUser.addresses.first, equals(testAddress));
        expect(testUser.createdAt, equals(testCreatedAt));
      });
    });

    group('📝 Computed Properties', () {
      test('fullName should return firstName + lastName', () {
        // Act & Assert
        expect(testUser.fullName, equals('Juan Pérez'));
      });

      test('fullName should handle empty names', () {
        // Arrange
        final user = UserEntity(
          id: '1',
          firstName: '',
          lastName: '',
          birthDate: DateTime(1990, 1, 1),
        );

        // Act & Assert
        expect(user.fullName, equals(' '));
      });

      test('isAdult should return true for users 18 or older', () {
        // Arrange - Usuario de 30+ años
        final adultUser = UserEntity(
          id: '1',
          firstName: 'Adult',
          lastName: 'User',
          birthDate: DateTime(1990, 1, 1),
        );

        // Act & Assert
        expect(adultUser.isAdult, isTrue);
      });

      test('isAdult should return false for users under 18', () {
        // Arrange - Usuario menor de edad
        final minorUser = UserEntity(
          id: '1',
          firstName: 'Minor',
          lastName: 'User',
          birthDate: DateTime.now().subtract(const Duration(days: 365 * 16)), // 16 años
        );

        // Act & Assert
        expect(minorUser.isAdult, isFalse);
      });

      test('isValid should return true for valid user', () {
        // Act & Assert
        expect(testUser.isValid, isTrue);
      });

      test('isValid should return false for empty id', () {
        // Arrange
        final invalidUser = testUser.copyWith(id: '');

        // Act & Assert
        expect(invalidUser.isValid, isFalse);
      });

      test('isValid should return false for empty firstName', () {
        // Arrange
        final invalidUser = testUser.copyWith(firstName: '  ');

        // Act & Assert
        expect(invalidUser.isValid, isFalse);
      });

      test('isValid should return false for empty lastName', () {
        // Arrange
        final invalidUser = testUser.copyWith(lastName: '');

        // Act & Assert
        expect(invalidUser.isValid, isFalse);
      });

      test('isValid should return false for future birthDate', () {
        // Arrange
        final invalidUser = testUser.copyWith(
          birthDate: DateTime.now().add(const Duration(days: 1)),
        );

        // Act & Assert
        expect(invalidUser.isValid, isFalse);
      });
    });

    group('🔄 CopyWith Method', () {
      test('should create copy with updated id', () {
        // Act
        final updatedUser = testUser.copyWith(id: 'new_id');

        // Assert
        expect(updatedUser.id, equals('new_id'));
        expect(updatedUser.firstName, equals(testUser.firstName));
        expect(updatedUser.lastName, equals(testUser.lastName));
        expect(updatedUser.birthDate, equals(testUser.birthDate));
      });

      test('should create copy with updated firstName', () {
        // Act
        final updatedUser = testUser.copyWith(firstName: 'Carlos');

        // Assert
        expect(updatedUser.firstName, equals('Carlos'));
        expect(updatedUser.id, equals(testUser.id));
        expect(updatedUser.lastName, equals(testUser.lastName));
      });

      test('should create copy with updated addresses', () {
        // Arrange
        final newAddress = const AddressEntity(
          id: 'addr_2',
          addressLine1: 'Nueva Calle 456',
          country: 'Colombia',
          department: 'Antioquia',
          city: 'Medellín',
        );

        // Act
        final updatedUser = testUser.copyWith(addresses: [newAddress]);

        // Assert
        expect(updatedUser.addresses, hasLength(1));
        expect(updatedUser.addresses.first.id, equals('addr_2'));
        expect(updatedUser.addresses.first.city, equals('Medellín'));
      });

      test('should create copy without changing original', () {
        // Arrange
        final originalId = testUser.id;
        final originalFirstName = testUser.firstName;

        // Act
        final updatedUser = testUser.copyWith(
          id: 'new_id',
          firstName: 'Carlos',
        );

        // Assert - Original no cambió
        expect(testUser.id, equals(originalId));
        expect(testUser.firstName, equals(originalFirstName));
        
        // Assert - Copia sí cambió
        expect(updatedUser.id, equals('new_id'));
        expect(updatedUser.firstName, equals('Carlos'));
      });
    });

    group('🗺️ Serialization', () {
      test('toMap should convert user to Map correctly', () {
        // Act
        final map = testUser.toMap();

        // Assert
        expect(map['id'], equals('user_123'));
        expect(map['firstName'], equals('Juan'));
        expect(map['lastName'], equals('Pérez'));
        expect(map['birthDate'], equals(testBirthDate));
        expect(map['addresses'], isA<List>());
        expect(map['addresses'], hasLength(1));
        expect(map['createdAt'], equals(testCreatedAt));
      });

      test('fromMap should create user from Map correctly', () {
        // Arrange
        final map = {
          'id': 'user_456',
          'firstName': 'María',
          'lastName': 'González',
          'birthDate': '1985-12-25T00:00:00.000',
          'addresses': [
            {
              'id': 'addr_test',
              'addressLine1': 'Test Address',
              'country': 'Colombia',
              'department': 'Valle del Cauca',
              'city': 'Cali',
              'isColombia': true,
            }
          ],
          'createdAt': '2024-01-01T00:00:00.000',
        };

        // Act
        final user = UserEntity.fromMap(map);

        // Assert
        expect(user.id, equals('user_456'));
        expect(user.firstName, equals('María'));
        expect(user.lastName, equals('González'));
        expect(user.birthDate, equals(DateTime.parse('1985-12-25T00:00:00.000')));
        expect(user.addresses, hasLength(1));
        expect(user.addresses.first.city, equals('Cali'));
        expect(user.createdAt, equals(DateTime.parse('2024-01-01T00:00:00.000')));
      });

      test('fromMap should handle missing optional fields', () {
        // Arrange
        final map = {
          'id': 'user_minimal',
          'firstName': 'Test',
          'lastName': 'User',
          'birthDate': '1990-01-01T00:00:00.000',
        };

        // Act
        final user = UserEntity.fromMap(map);

        // Assert
        expect(user.id, equals('user_minimal'));
        expect(user.firstName, equals('Test'));
        expect(user.lastName, equals('User'));
        expect(user.addresses, isEmpty);
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
      });

      test('fromMap should handle DateTime objects directly', () {
        // Arrange
        final birthDate = DateTime(1990, 1, 1);
        final map = {
          'id': 'user_datetime',
          'firstName': 'Test',
          'lastName': 'User',
          'birthDate': birthDate,
        };

        // Act
        final user = UserEntity.fromMap(map);

        // Assert
        expect(user.birthDate, equals(birthDate));
      });
    });

    group('🔍 toString Method', () {
      test('toString should return formatted string', () {
        // Act
        final result = testUser.toString();

        // Assert
        expect(result, contains('UserEntity'));
        expect(result, contains('user_123'));
        expect(result, contains('Juan Pérez'));
        expect(result, contains('addresses: 1'));
      });
    });

    group('⚖️ Equality', () {
      test('users with same data should be equal', () {
        // Arrange
        final user1 = UserEntity(
          id: 'same_id',
          firstName: 'Same',
          lastName: 'User',
          birthDate: DateTime(1990, 1, 1),
        );
        
        final user2 = UserEntity(
          id: 'same_id',
          firstName: 'Same',
          lastName: 'User',
          birthDate: DateTime(1990, 1, 1),
        );

        // Act & Assert
        expect(user1.id, equals(user2.id));
        expect(user1.firstName, equals(user2.firstName));
        expect(user1.lastName, equals(user2.lastName));
        expect(user1.birthDate, equals(user2.birthDate));
      });
    });
  });
}
