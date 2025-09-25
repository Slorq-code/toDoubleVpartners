import 'address_entity.dart';

class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<AddressEntity> addresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
    this.createdAt,
    this.updatedAt,
  });

  // Propiedad calculada: nombre completo
  String get fullName => '$firstName $lastName';
  
  // Propiedad calculada: verificar si es mayor de edad
  bool get isAdult {
    final age = (DateTime.now().difference(birthDate).inDays / 365).floor();
    return age >= 18;
  }

  // Validación básica del usuario
  bool get isValid => 
      id.isNotEmpty &&
      firstName.trim().isNotEmpty && 
      lastName.trim().isNotEmpty &&
      birthDate.isBefore(DateTime.now());

  // Método para crear una copia con algunos campos actualizados
  UserEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<AddressEntity>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'addresses': addresses.map((address) => address.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Crear desde Map de Firestore
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthDate: map['birthDate'] is DateTime 
          ? map['birthDate'] 
          : DateTime.parse(map['birthDate']),
      addresses: (map['addresses'] as List<dynamic>?)
          ?.map((addressMap) => AddressEntity.fromMap(addressMap))
          .toList() ?? [],
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : (map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null),
      updatedAt: map['updatedAt'] is DateTime 
          ? map['updatedAt'] 
          : (map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null),
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, fullName: $fullName, birthDate: $birthDate, addresses: ${addresses.length})';
  }
}
