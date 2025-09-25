import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/user_entity.dart';
import 'package:to_double_v_partners/domain/services/user_service.dart';

/// Estado para la lista de usuarios
class UsersState {
  final List<UserEntity> users;
  final bool isLoading;
  final String? error;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UsersState copyWith({
    List<UserEntity>? users,
    bool? isLoading,
    String? error,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para manejar la lista de usuarios
class UsersNotifier extends StateNotifier<UsersState> {
  final UserService _userService;

  UsersNotifier(this._userService) : super(const UsersState());

  /// Cargar todos los usuarios
  Future<void> loadUsers() async {
    print('📋 Cargando usuarios...');
    
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _userService.getAllUsers();
      
      print('✅ Usuarios cargados: ${users.length}');
      for (int i = 0; i < users.length; i++) {
        final user = users[i];
        print('👤 Usuario ${i + 1}: ${user.fullName} (${user.addresses.length} direcciones)');
      }

      state = state.copyWith(
        users: users,
        isLoading: false,
      );
    } catch (e) {
      print('❌ Error al cargar usuarios: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Actualizar la lista después de agregar un usuario
  Future<void> refreshUsers() async {
    await loadUsers();
  }

  /// Eliminar un usuario
  Future<void> deleteUser(String userId) async {
    print('🗑️ Eliminando usuario: $userId');
    
    try {
      await _userService.deleteUser(userId);
      
      // Actualizar la lista local
      final updatedUsers = state.users.where((user) => user.id != userId).toList();
      state = state.copyWith(users: updatedUsers);
      
      print('✅ Usuario eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar usuario: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para el servicio de usuarios
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// Provider para la lista de usuarios
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final userService = ref.read(userServiceProvider);
  return UsersNotifier(userService);
});
