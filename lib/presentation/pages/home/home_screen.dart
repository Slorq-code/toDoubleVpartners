import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/user_entity.dart';
import 'package:to_double_v_partners/presentation/pages/register/register_user_screen.dart';
import 'package:to_double_v_partners/presentation/providers/users_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersProvider.notifier).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios (${usersState.users.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              print('Agregar usuario');
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterUserScreen(),
                ),
              );
              
              // Si se agregó un usuario, actualizar la lista
              if (result == true || mounted) {
                ref.read(usersProvider.notifier).refreshUsers();
              }
            },
            tooltip: 'Agregar usuario',
          ),
        ],
      ),
      body: _buildBody(context, theme, usersState),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, UsersState usersState) {
    // Mostrar loading
    if (usersState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando usuarios...'),
          ],
        ),
      );
    }

    // Mostrar error
    if (usersState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar usuarios',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usersState.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(usersProvider.notifier).clearError();
                ref.read(usersProvider.notifier).loadUsers();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // Mostrar lista vacía
    if (usersState.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios registrados',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega el primer usuario tocando el botón +',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'En la parte superior derecha',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Mostrar lista de usuarios
    return RefreshIndicator(
      onRefresh: () => ref.read(usersProvider.notifier).refreshUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: usersState.users.length,
        itemBuilder: (context, index) {
          final user = usersState.users[index];
          return _buildUserCard(context, theme, user);
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, ThemeData theme, UserEntity user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre y acciones
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${user.id}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () => _showDeleteConfirmation(context, user),
                  tooltip: 'Eliminar usuario',
                ),
              ],
            ),
            
            const SizedBox(height: 12.0),
            
            // Información del usuario
            _buildInfoRow(
              theme: theme,
              icon: Icons.cake,
              label: 'Fecha de nacimiento',
              value: '${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year}',
            ),
            
            const SizedBox(height: 8.0),
            
            _buildInfoRow(
              theme: theme,
              icon: Icons.location_on,
              label: 'Direcciones',
              value: '${user.addresses.length} ${user.addresses.length == 1 ? 'dirección' : 'direcciones'}',
            ),
            
            if (user.addresses.isNotEmpty) ...[
              const SizedBox(height: 12.0),
              const Divider(),
              const SizedBox(height: 8.0),
              Text(
                'Direcciones:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              ...user.addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dirección ${index + 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          address.formattedAddress,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            
            const SizedBox(height: 8.0),
            
            // Timestamps
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Creado: ${_formatDate(user.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8.0),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Estás seguro de que deseas eliminar a ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(usersProvider.notifier).deleteUser(user.id);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario ${user.fullName} eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
