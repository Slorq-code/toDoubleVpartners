import '../../domain/entities/address_entity.dart';

class AddressModel {
  final String id;
  final String addressLine1;
  final String? addressLine2;
  final String country;
  final String department;
  final String city;
  final String? postalCode;
  final bool isPrimary;
  final bool isColombia;

  const AddressModel({
    required this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.country,
    required this.department,
    required this.city,
    this.postalCode,
    this.isPrimary = false,
    this.isColombia = true,
  });

  // Convertir de Map a AddressModel
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'],
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'],
      isPrimary: map['isPrimary'] ?? false,
      isColombia: map['isColombia'] ?? true,
    );
  }

  // Convertir de AddressModel a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'country': country,
      'department': department,
      'city': city,
      'postalCode': postalCode,
      'isPrimary': isPrimary,
      'isColombia': isColombia,
    };
  }

  // Convertir de Entity a Model
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      addressLine1: entity.addressLine1,
      addressLine2: entity.addressLine2,
      country: entity.country,
      department: entity.department,
      city: entity.city,
      postalCode: entity.postalCode,
      isPrimary: entity.isPrimary,
      isColombia: entity.isColombia,
    );
  }

  // Convertir de Model a Entity
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      country: country,
      department: department,
      city: city,
      postalCode: postalCode,
      isPrimary: isPrimary,
      isColombia: isColombia,
    );
  }
}
