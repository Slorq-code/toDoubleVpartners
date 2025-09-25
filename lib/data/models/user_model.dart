import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import 'address_model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<AddressModel> addresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
    this.createdAt,
    this.updatedAt,
  });

  // Convertir de Map a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      addresses: (map['addresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convertir de Model a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': Timestamp.fromDate(birthDate),
      'addresses': addresses.map((e) => e.toMap()).toList(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Convertir de Entity a Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      birthDate: entity.birthDate,
      addresses: entity.addresses
          .map((e) => AddressModel.fromEntity(e))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Convertir de Model a Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      addresses: addresses.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
