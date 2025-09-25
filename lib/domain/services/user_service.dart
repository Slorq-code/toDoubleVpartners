import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';
import 'package:to_double_v_partners/domain/entities/user_entity.dart';

/// Servicio para manejar operaciones de usuarios en Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  /// Crear un nuevo usuario en Firestore
  Future<String> createUser({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required List<AddressEntity> addresses,
  }) async {
    try {
      print('🔥 Iniciando creación de usuario en Firestore...');
      print('📝 Datos del usuario:');
      print('  - Nombre: $firstName');
      print('  - Apellido: $lastName');
      print('  - Fecha de nacimiento: $birthDate');
      print('  - Direcciones: ${addresses.length}');
      
      // Mostrar detalles de cada dirección
      for (int i = 0; i < addresses.length; i++) {
        final address = addresses[i];
        print('📍 Dirección ${i + 1}:');
        print('    - ID: ${address.id}');
        print('    - País: ${address.country}');
        print('    - Departamento: ${address.department}');
        print('    - Ciudad: ${address.city}');
        print('    - Dirección 1: ${address.addressLine1}');
        print('    - Dirección 2: ${address.addressLine2}');
        print('    - Es Colombia: ${address.isColombia}');
        print('    - Es principal: ${address.isPrimary}');
      }

      // Crear el documento del usuario
      final userDoc = _firestore.collection(_usersCollection).doc();
      final userId = userDoc.id;

      // Convertir direcciones a Map
      final addressesData = addresses.map((address) => address.toMap()).toList();
      
      print('🔄 Direcciones convertidas a Map:');
      for (int i = 0; i < addressesData.length; i++) {
        print('📍 Dirección ${i + 1} (Map): ${addressesData[i]}');
      }

      // Datos del usuario
      final userData = {
        'id': userId,
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': Timestamp.fromDate(birthDate),
        'addresses': addressesData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      print('💾 Guardando usuario con ID: $userId');
      print('📄 Datos completos a guardar: $userData');
      
      // Guardar en Firestore
      await userDoc.set(userData);

      print('✅ Usuario creado exitosamente en Firestore');
      print('🆔 ID del usuario: $userId');
      
      return userId;
    } catch (e) {
      print('❌ Error al crear usuario en Firestore: $e');
      rethrow;
    }
  }

  /// Actualizar un usuario existente
  Future<void> updateUser({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required List<AddressEntity> addresses,
  }) async {
    try {
      print('🔥 Actualizando usuario en Firestore...');
      print('🆔 ID del usuario: $userId');

      final userDoc = _firestore.collection(_usersCollection).doc(userId);

      // Convertir direcciones a Map
      final addressesData = addresses.map((address) => address.toMap()).toList();

      // Datos actualizados
      final userData = {
        'firstName': firstName,
        'lastName': lastName,
        'birthDate': Timestamp.fromDate(birthDate),
        'addresses': addressesData,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await userDoc.update(userData);

      print('✅ Usuario actualizado exitosamente');
    } catch (e) {
      print('❌ Error al actualizar usuario: $e');
      rethrow;
    }
  }

  /// Obtener un usuario por ID
  Future<UserEntity?> getUserById(String userId) async {
    try {
      print('🔍 Buscando usuario con ID: $userId');
      
      final userDoc = await _firestore.collection(_usersCollection).doc(userId).get();
      
      if (!userDoc.exists) {
        print('❌ Usuario no encontrado');
        return null;
      }

      final data = userDoc.data()!;
      
      // Convertir direcciones de Map a AddressEntity
      final addressesData = data['addresses'] as List<dynamic>? ?? [];
      final addresses = addressesData
          .map((addressMap) => AddressEntity.fromMap(addressMap as Map<String, dynamic>))
          .toList();

      final user = UserEntity(
        id: data['id'] as String,
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        birthDate: (data['birthDate'] as Timestamp).toDate(),
        addresses: addresses,
        createdAt: data['createdAt'] != null 
            ? (data['createdAt'] as Timestamp).toDate() 
            : DateTime.now(),
        updatedAt: data['updatedAt'] != null 
            ? (data['updatedAt'] as Timestamp).toDate() 
            : DateTime.now(),
      );

      print('✅ Usuario encontrado: ${user.firstName} ${user.lastName}');
      return user;
    } catch (e) {
      print('❌ Error al obtener usuario: $e');
      rethrow;
    }
  }

  /// Eliminar un usuario
  Future<void> deleteUser(String userId) async {
    try {
      print('🗑️ Eliminando usuario con ID: $userId');
      
      await _firestore.collection(_usersCollection).doc(userId).delete();
      
      print('✅ Usuario eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar usuario: $e');
      rethrow;
    }
  }

  /// Obtener todos los usuarios (para administración)
  Future<List<UserEntity>> getAllUsers() async {
    try {
      print('📋 Obteniendo todos los usuarios...');
      
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        
        // Convertir direcciones
        final addressesData = data['addresses'] as List<dynamic>? ?? [];
        final addresses = addressesData
            .map((addressMap) => AddressEntity.fromMap(addressMap as Map<String, dynamic>))
            .toList();

        return UserEntity(
          id: data['id'] as String,
          firstName: data['firstName'] as String,
          lastName: data['lastName'] as String,
          birthDate: (data['birthDate'] as Timestamp).toDate(),
          addresses: addresses,
          createdAt: data['createdAt'] != null 
              ? (data['createdAt'] as Timestamp).toDate() 
              : DateTime.now(),
          updatedAt: data['updatedAt'] != null 
              ? (data['updatedAt'] as Timestamp).toDate() 
              : DateTime.now(),
        );
      }).toList();

      print('✅ Obtenidos ${users.length} usuarios');
      return users;
    } catch (e) {
      print('❌ Error al obtener usuarios: $e');
      rethrow;
    }
  }
}
