import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/user_entity.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';

// Clase para manejar el estado del registro
class RegisterState {
  final UserEntity user;
  final bool isLoading;
  final String? error;

  RegisterState({
    required this.user,
    this.isLoading = false,
    this.error,
  });

  RegisterState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return RegisterState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(
    RegisterState(
      user: UserEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        firstName: '',
        lastName: '',
        birthDate: DateTime.now(), // Usar la fecha actual como valor por defecto
        addresses: [],
      ),
    ),
  );

  void updatePersonalInfo({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
  }) {
    state = state.copyWith(
      user: state.user.copyWith(
        firstName: firstName ?? state.user.firstName,
        lastName: lastName ?? state.user.lastName,
        birthDate: birthDate ?? state.user.birthDate,
      ),
    );
  }

  void addAddress(AddressEntity address) {
    final addresses = List<AddressEntity>.from(state.user.addresses);
    // Si es la primera dirección, marcarla como principal
    if (addresses.isEmpty) {
      address = address.copyWith(isPrimary: true);
    }
    addresses.add(address);
    state = state.copyWith(
      user: state.user.copyWith(addresses: addresses),
    );
  }

  void updateAddress(int index, AddressEntity address) {
    final addresses = List<AddressEntity>.from(state.user.addresses);
    if (index < addresses.length) {
      addresses[index] = address;
      state = state.copyWith(
      user: state.user.copyWith(addresses: addresses),
    );
    }
  }

  void removeAddress(int index) {
    final addresses = List<AddressEntity>.from(state.user.addresses);
    if (index < addresses.length) {
      final isRemovingPrimary = addresses[index].isPrimary;
      addresses.removeAt(index);
      
      // Si se eliminó la dirección principal y aún hay direcciones,
      // marcar la primera como principal
      if (isRemovingPrimary && addresses.isNotEmpty) {
        addresses[0] = addresses[0].copyWith(isPrimary: true);
      }
      
      state = state.copyWith(
      user: state.user.copyWith(addresses: addresses),
    );
    }
  }

  void setPrimaryAddress(int index) {
    final addresses = state.user.addresses.asMap().entries.map((entry) {
      return entry.value.copyWith(isPrimary: entry.key == index);
    }).toList();
    state = state.copyWith(
      user: state.user.copyWith(addresses: addresses),
    );
  }

  bool validatePersonalInfo() {
    return state.user.firstName.isNotEmpty && 
           state.user.lastName.isNotEmpty && 
           state.user.birthDate != null;
  }

  bool validateAddresses() {
    if (state.user.addresses.isEmpty) return false;
    
    for (final address in state.user.addresses) {
      if (address.addressLine1.isEmpty || 
          address.city.isEmpty || 
          address.department.isEmpty || 
          address.country.isEmpty) {
        return false;
      }
    }
    
    return true;
  }

  bool canProceedToNextStep(int currentStep) {
    switch (currentStep) {
      case 0: // Información personal
        return validatePersonalInfo();
      case 1: // Dirección
        return validateAddresses();
      case 2: // Confirmación
        return true;
      default:
        return false;
    }
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});

// Provider for the current step in the registration process
final currentStepProvider = StateProvider<int>((ref) => 0);

// Provider for the form key
final personalInfoFormKeyProvider = Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

// Provider for the address form key
final addressFormKeyProvider = Provider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());
