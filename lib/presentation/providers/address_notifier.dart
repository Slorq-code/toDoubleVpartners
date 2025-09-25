import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/repositories/address_repository.dart';
import 'package:to_double_v_partners/presentation/providers/address_provider.dart';

// Provider para el repositorio de direcciones
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository();
});

// Provider para el estado del formulario de dirección
class AddressFormNotifier extends StateNotifier<AddressFormState> {
  final Ref ref;
  
  AddressFormNotifier(this.ref) : super(AddressFormState()) {
    _loadDepartments();
  }

  // Cargar departamentos
  Future<void> _loadDepartments() async {
    if (state.departments.isNotEmpty) return;
    
    state = state.copyWith(isLoadingDepartments: true);
    
    try {
      final repository = ref.read(addressRepositoryProvider);
      final departments = await repository.loadColombianDepartments();
      
      state = state.copyWith(
        departments: departments.map((d) => d.name).toList(),
        isLoadingDepartments: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar los departamentos',
        isLoadingDepartments: false,
      );
    }
  }

  // Cargar ciudades de un departamento
  Future<void> loadCities(String departmentName) async {
    if (departmentName.isEmpty) {
      state = state.copyWith(cities: []);
      return;
    }

    state = state.copyWith(
      department: departmentName,
      city: null,
      isLoadingCities: true,
    );

    try {
      final repository = ref.read(addressRepositoryProvider);
      final cities = await repository.getCitiesByDepartment(departmentName);
      
      state = state.copyWith(
        cities: cities,
        isLoadingCities: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error al cargar las ciudades',
        isLoadingCities: false,
      );
    }
  }

  // Actualizar el estado del formulario
  void updateForm({
    bool? isExpanded,
    bool? isColombia,
    String? country,
    String? department,
    String? city,
    String? addressLine1,
    String? addressLine2,
  }) {
    print('📝 ACTUALIZANDO FORMULARIO:');
    if (isExpanded != null) print('  - isExpanded: $isExpanded');
    if (isColombia != null) print('  - isColombia: $isColombia');
    if (country != null) print('  - country: "$country"');
    if (department != null) print('  - department: "$department"');
    if (city != null) print('  - city: "$city"');
    if (addressLine1 != null) print('  - addressLine1: "$addressLine1"');
    if (addressLine2 != null) print('  - addressLine2: "$addressLine2"');
    
    state = state.copyWith(
      isExpanded: isExpanded ?? state.isExpanded,
      isColombia: isColombia ?? state.isColombia,
      country: country ?? state.country,
      department: department ?? state.department,
      city: city ?? state.city,
      addressLine1: addressLine1 ?? state.addressLine1,
      addressLine2: addressLine2 ?? state.addressLine2,
    );
    
    print('📊 ESTADO DESPUÉS DE ACTUALIZAR:');
    print('  - País: "${state.country}"');
    print('  - Departamento: "${state.department}"');
    print('  - Ciudad: "${state.city}"');
    print('  - Dirección principal: "${state.addressLine1}"');
    print('  - Dirección complemento: "${state.addressLine2}"');
    print('  - Formulario válido: ${state.isFormValid}');
    print('');
    
    // Si se actualiza el departamento y estamos en Colombia, cargar las ciudades
    if (department != null && state.isColombia) {
      loadCities(department);
    }
  }

  // Cambiar el tipo de dirección (Colombia/Internacional)
  void toggleCountryType(bool isColombia) {
    print('🌎 TOGGLE COUNTRY TYPE - isColombia: $isColombia');
    print('🌎 ESTABLECIENDO PAÍS COMO: ${isColombia ? "Colombia" : "null"}');
    
    state = state.copyWith(
      isColombia: isColombia,
      country: isColombia ? 'Colombia' : null,
      department: null, // Limpiar siempre al cambiar
      city: null, // Limpiar siempre al cambiar
      departments: isColombia ? state.departments : [],
      cities: [], // Limpiar ciudades siempre
    );
    
    print('🌎 ESTADO DESPUÉS DE TOGGLE:');
    print('  - isColombia: ${state.isColombia}');
    print('  - country: "${state.country}"');
    print('  - department: "${state.department}"');
    print('  - city: "${state.city}"');
    print('');
    
    // Si cambiamos a Colombia y no tenemos departamentos, cargarlos
    if (isColombia && state.departments.isEmpty) {
      _loadDepartments();
    }
  }

  // Expandir/contraer el formulario
  void toggleExpanded() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  // Limpiar el formulario
  void resetForm() {
    state = AddressFormState(
      isColombia: state.isColombia,
      departments: state.departments,
    );
  }
}

// Provider para el notificador del formulario de dirección
final addressFormProvider = StateNotifierProvider<AddressFormNotifier, AddressFormState>((ref) {
  return AddressFormNotifier(ref);
});
