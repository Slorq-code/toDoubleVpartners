
// Estado para el formulario de dirección
class AddressFormState {
  final bool isExpanded;
  final bool isColombia;
  final String? country;
  final String? department;
  final String? city;
  final String? addressLine1;
  final String? addressLine2;
  final bool isLoadingDepartments;
  final bool isLoadingCities;
  final List<String> departments;
  final List<String> cities;
  final String? error;

  AddressFormState({
    this.isExpanded = false,
    this.isColombia = true,
    this.country = 'Colombia',
    this.department,
    this.city,
    this.addressLine1,
    this.addressLine2,
    this.isLoadingDepartments = false,
    this.isLoadingCities = false,
    this.departments = const [],
    this.cities = const [],
    this.error,
  });

  // Verificar si el formulario es válido
  bool get isFormValid {
    final isValid = country?.isNotEmpty == true &&
        department?.isNotEmpty == true &&
        city?.isNotEmpty == true &&
        addressLine1?.isNotEmpty == true;
    return isValid;
  }

  // Crear una copia del estado con algunos campos actualizados
  AddressFormState copyWith({
    bool? isExpanded,
    bool? isColombia,
    String? country,
    String? department,
    String? city,
    String? addressLine1,
    String? addressLine2,
    bool? isLoadingDepartments,
    bool? isLoadingCities,
    List<String>? departments,
    List<String>? cities,
    String? error,
  }) {
    return AddressFormState(
      isExpanded: isExpanded ?? this.isExpanded,
      isColombia: isColombia ?? this.isColombia,
      country: country ?? this.country,
      department: department ?? this.department,
      city: city ?? this.city,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      isLoadingDepartments: isLoadingDepartments ?? this.isLoadingDepartments,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      departments: departments ?? this.departments,
      cities: cities ?? this.cities,
      error: error,
    );
  }
}
