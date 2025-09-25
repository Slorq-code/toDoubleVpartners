import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';
import 'package:to_double_v_partners/presentation/providers/address_notifier.dart';
import 'package:to_double_v_partners/presentation/providers/address_provider.dart';

/// Helper class que maneja toda la lógica del formulario de direcciones
/// Separa las responsabilidades de lógica de negocio de la UI
class AddressFormHelper {
  final WidgetRef ref;
  final GlobalKey<FormState> formKey;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController otherCountryController;
  final TextEditingController otherDepartmentController;
  final TextEditingController otherCityController;

  AddressFormHelper({
    required this.ref,
    required this.formKey,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.otherCountryController,
    required this.otherDepartmentController,
    required this.otherCityController,
  });

  /// Factory constructor que crea controladores automáticamente
  factory AddressFormHelper.create({
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    AddressEntity? initialAddress,
  }) {
    return AddressFormHelper(
      ref: ref,
      formKey: formKey,
      addressLine1Controller: TextEditingController(
        text: initialAddress?.addressLine1 ?? '',
      ),
      addressLine2Controller: TextEditingController(
        text: initialAddress?.addressLine2 ?? '',
      ),
      otherCountryController: TextEditingController(
        text: initialAddress?.isColombia == false ? initialAddress?.country ?? '' : '',
      ),
      otherDepartmentController: TextEditingController(
        text: initialAddress?.isColombia == false ? initialAddress?.department ?? '' : '',
      ),
      otherCityController: TextEditingController(
        text: initialAddress?.isColombia == false ? initialAddress?.city ?? '' : '',
      ),
    );
  }

  /// Inicializar el formulario con una dirección existente (para edición)
  void initializeWithAddress(AddressEntity? address) {
    if (address == null) return;

    // Inicializar controladores con valores existentes
    addressLine1Controller.text = address.addressLine1;
    addressLine2Controller.text = address.addressLine2 ?? '';
    
    if (!address.isColombia) {
      otherCountryController.text = address.country;
      otherDepartmentController.text = address.department;
      otherCityController.text = address.city;
    }

    // Inicializar estado del formulario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(addressFormProvider.notifier);
      notifier.updateForm(
        isColombia: address.isColombia,
        country: address.country,
        department: address.department,
        city: address.city,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2,
      );
    });
  }

  /// Limpiar controladores cuando se cambia el tipo de país
  void handleCountryTypeChange(bool isColombia) {
    if (isColombia) {
      // Si cambiamos a Colombia, limpiar campos internacionales
      otherCountryController.clear();
      otherDepartmentController.clear();
      otherCityController.clear();
    }
  }

  /// Alternar entre Colombia y otros países
  void toggleCountryType(bool isColombia) {
    print('🌎 CAMBIANDO TIPO DE PAÍS: ${isColombia ? "Colombia" : "Otro"}');
    ref.read(addressFormProvider.notifier).toggleCountryType(isColombia);
  }

  /// Expandir o contraer el formulario
  void toggleExpanded() {
    ref.read(addressFormProvider.notifier).toggleExpanded();
  }

  /// Expandir el formulario para editar una dirección existente
  void expandForEdit(AddressEntity address) {
    // Primero expandir el formulario
    ref.read(addressFormProvider.notifier).updateForm(isExpanded: true);
    
    // Luego inicializar con los datos de la dirección
    initializeWithAddress(address);
  }

  /// Actualizar campo de dirección principal
  void updateAddressLine1() {
    print('🏠 ACTUALIZANDO DIRECCIÓN PRINCIPAL: "${addressLine1Controller.text}"');
    ref.read(addressFormProvider.notifier).updateForm(
      addressLine1: addressLine1Controller.text,
    );
  }

  /// Actualizar campo de complemento de dirección
  void updateAddressLine2() {
    print('🏠 ACTUALIZANDO COMPLEMENTO: "${addressLine2Controller.text}"');
    ref.read(addressFormProvider.notifier).updateForm(
      addressLine2: addressLine2Controller.text,
    );
  }

  /// Actualizar departamento (para Colombia)
  void updateDepartment(String department) {
    print('🏛️ ACTUALIZANDO DEPARTAMENTO: "$department"');
    ref.read(addressFormProvider.notifier).updateForm(department: department);
  }

  /// Actualizar ciudad (para Colombia)
  void updateCity(String city) {
    print('🏙️ ACTUALIZANDO CIUDAD: "$city"');
    ref.read(addressFormProvider.notifier).updateForm(city: city);
  }

  /// Actualizar país (para otros países)
  void updateCountry() {
    final currentState = ref.read(addressFormProvider);
    // Solo actualizar el país si NO estamos en Colombia
    if (!currentState.isColombia) {
      print('🌍 ACTUALIZANDO PAÍS (INTERNACIONAL): "${otherCountryController.text}"');
      ref.read(addressFormProvider.notifier).updateForm(
        country: otherCountryController.text,
      );
    } else {
      print('🌍 IGNORANDO ACTUALIZACIÓN DE PAÍS (estamos en Colombia)');
    }
  }

  /// Actualizar departamento/estado (para otros países)
  void updateInternationalDepartment() {
    final currentState = ref.read(addressFormProvider);
    // Solo actualizar si NO estamos en Colombia
    if (!currentState.isColombia) {
      print('🏛️ ACTUALIZANDO DEPARTAMENTO (INTERNACIONAL): "${otherDepartmentController.text}"');
      ref.read(addressFormProvider.notifier).updateForm(
        department: otherDepartmentController.text,
      );
    } else {
      print('🏛️ IGNORANDO ACTUALIZACIÓN DEPARTAMENTO (estamos en Colombia)');
    }
  }

  /// Actualizar ciudad (para otros países)
  void updateInternationalCity() {
    final currentState = ref.read(addressFormProvider);
    // Solo actualizar si NO estamos en Colombia
    if (!currentState.isColombia) {
      print('🏙️ ACTUALIZANDO CIUDAD (INTERNACIONAL): "${otherCityController.text}"');
      ref.read(addressFormProvider.notifier).updateForm(
        city: otherCityController.text,
      );
    } else {
      print('🏙️ IGNORANDO ACTUALIZACIÓN CIUDAD (estamos en Colombia)');
    }
  }

  /// Validar si un valor está en la lista de opciones del dropdown
  String? getValidDropdownValue(String? value, List<String> options) {
    return options.contains(value) ? value : null;
  }

  /// Crear una nueva dirección con los datos del formulario
  AddressEntity createAddressEntity({
    String? existingId,
    bool? isPrimary,
  }) {
    final state = ref.read(addressFormProvider);
    
    return AddressEntity(
      id: existingId ?? DateTime.now().toString(),
      isColombia: state.isColombia,
      country: state.isColombia ? 'Colombia' : (state.country ?? ''),
      department: state.department ?? '',
      city: state.city ?? '',
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      postalCode: null,
      isPrimary: isPrimary ?? false,
    );
  }

  /// Guardar la dirección
  void saveAddress({
    AddressEntity? initialAddress,
    Function(AddressEntity)? onSave,
  }) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final newAddress = createAddressEntity(
      existingId: initialAddress?.id,
      isPrimary: initialAddress?.isPrimary,
    );

    if (onSave != null) {
      onSave(newAddress);
    }

    // Reset form if not in edit mode
    if (initialAddress == null) {
      resetForm();
    }
  }

  /// Resetear el formulario
  void resetForm() {
    formKey.currentState?.reset();
    ref.read(addressFormProvider.notifier).resetForm();
    
    // Limpiar todos los controladores
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    otherCountryController.clear();
    otherDepartmentController.clear();
    otherCityController.clear();
  }

  /// Limpiar todos los controladores
  void disposeControllers() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    otherCountryController.dispose();
    otherDepartmentController.dispose();
    otherCityController.dispose();
  }

  /// Obtener el estado actual del formulario
  AddressFormState get currentState => ref.read(addressFormProvider);

  /// Verificar si el formulario es válido
  bool get isFormValid => currentState.isFormValid;
}
