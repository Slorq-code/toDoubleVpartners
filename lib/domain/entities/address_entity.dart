class AddressEntity {
  final String id;
  final String addressLine1;
  final String? addressLine2; // Complemento de dirección (opcional)
  final String country; // 'Colombia' u otro país
  final String department; // Departamento o provincia/estado
  final String city; // Ciudad o municipio
  final String? postalCode; // Código postal (opcional)
  final bool isPrimary;
  final bool isColombia; // Para saber si es una dirección colombiana

  const AddressEntity({
    required this.id,
    required this.addressLine1,
    this.addressLine2,
    required this.country,
    required this.department,
    required this.city,
    this.postalCode,
    this.isPrimary = false,
    this.isColombia = true, // Por defecto asumimos que es Colombia
  });

  // Método para crear una copia con algunos campos actualizados
  AddressEntity copyWith({
    String? id,
    String? addressLine1,
    String? addressLine2,
    String? country,
    String? department,
    String? city,
    String? postalCode,
    bool? isPrimary,
    bool? isColombia,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      country: country ?? this.country,
      department: department ?? this.department,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isPrimary: isPrimary ?? this.isPrimary,
      isColombia: isColombia ?? this.isColombia,
    );
  }

  // Método para obtener una representación en texto de la dirección
  String get formattedAddress {
    final addressParts = <String>[];
    
    // Agregar dirección principal
    addressParts.add(addressLine1);
    
    // Agregar complemento si existe
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      addressParts.add('Complemento: $addressLine2');
    }
    
    // Agregar ciudad y departamento/estado
    addressParts.add('$city, $department');
    
    // Agregar país
    addressParts.add(country);
    
    // Agregar código postal si existe
    if (postalCode != null && postalCode!.isNotEmpty) {
      addressParts.add('Código postal: $postalCode');
    }
    
    return addressParts.join('\n');
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'country': country,
      'department': department,
      'city': city,
      'isColombia': isColombia,
      // Nota: No incluimos postalCode ni isPrimary según los requerimientos
    };
  }

  // Crear desde Map de Firestore
  factory AddressEntity.fromMap(Map<String, dynamic> map) {
    return AddressEntity(
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

  @override
  String toString() {
    return 'AddressEntity(id: $id, addressLine1: $addressLine1, city: $city, country: $country)';
  }
}
