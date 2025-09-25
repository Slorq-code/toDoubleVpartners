import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';
import 'package:to_double_v_partners/domain/services/user_service.dart';
import 'package:to_double_v_partners/presentation/providers/address_provider.dart';
import 'package:to_double_v_partners/presentation/widgets/address_form.dart';
import 'package:to_double_v_partners/presentation/widgets/button.dart';
import 'package:to_double_v_partners/presentation/widgets/input_text.dart';

class RegisterUserScreen extends ConsumerStatefulWidget {
  final VoidCallback? onRemove;

  const RegisterUserScreen({
    super.key,
    this.onRemove,
  });

  @override
  ConsumerState<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends ConsumerState<RegisterUserScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Controladores para el formulario
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _birthDate;

  // Estados de validación
  bool get _isFirstNameValid => _firstNameController.text.trim().isNotEmpty;
  bool get _isLastNameValid => _lastNameController.text.trim().isNotEmpty;
  bool get _isBirthDateValid => _birthDate != null;
  
  // Lista de direcciones
  final List<AddressEntity> _addresses = [];

  // Servicio de usuario
  final UserService _userService = UserService();
  
  // Estado de carga
  bool _isLoading = false;

  // Estado para habilitar/deshabilitar el botón
  bool get _isNextButtonEnabled {
    switch (_currentStep) {
      case 0:
        return _isFirstNameValid && _isLastNameValid && _isBirthDateValid;
      case 1:
        return _addresses.isNotEmpty; // Habilitar solo si hay al menos una dirección
      case 2:
        return true; // Siempre habilitado en la pantalla de confirmación
      default:
        return false;
    }
  }

  // Títulos de los pasos
  final List<String> _stepTitles = [
    'Información Personal',
    'Dirección',
    'Confirmación',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      // Lógica para guardar el usuario
      _registerUser();
    }
  }

  void _onStepBack() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _registerUser() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      print('🚀 Iniciando registro de usuario...');
      print('📝 Datos a guardar:');
      print('  - Nombre: ${_firstNameController.text}');
      print('  - Apellido: ${_lastNameController.text}');
      print('  - Fecha de nacimiento: $_birthDate');
      print('  - Direcciones: ${_addresses.length}');

      // Crear usuario en Firestore
      final userId = await _userService.createUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDate!,
        addresses: _addresses,
      );

      print('✅ Usuario registrado exitosamente con ID: $userId');

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Usuario registrado exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Regresar a la pantalla anterior después de un delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('❌ Error al registrar usuario: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al registrar usuario: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Método para mostrar el selector de fecha
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    
    if (picked != null && picked != _birthDate) {
      if (mounted) {
        setState(() {
          _birthDate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_stepTitles[_currentStep]),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progreso
            _buildProgressIndicator(theme),
            
            // Contenido del formulario
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Paso 1: Información personal
                  _buildPersonalInfoStep(theme),
                  
                  // Paso 2: Dirección
                  _buildAddressStep(theme),
                  
                  // Paso 3: Confirmación
                  _buildConfirmationStep(theme),
                ],
              ),
            ),
            
            // Botones de navegación
            _buildNavigationButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Indicador de pasos
          Text(
            'Paso ${_currentStep + 1} de $_totalSteps',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep(ThemeData theme) {
    // Usar un Listener para detectar cambios en los controladores
    return Listener(
      onPointerDown: (_) {
        // Actualizar el estado cuando se interactúa con los campos
        if (mounted) setState(() {});
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nombre
            InputText(
              label: 'Nombre',
              placeholder: 'Escribe tu nombre',
              controller: _firstNameController,
              onTextChanged: (_) {
                if (mounted) setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            
            const SizedBox(height: 16),
            
            // Apellido
            InputText(
              label: 'Apellido',
              placeholder: 'Escribe tu apellido',
              controller: _lastNameController,
              onTextChanged: (_) {
                if (mounted) setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
          
            const SizedBox(height: 16),
            
            // Fecha de nacimiento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha de Nacimiento',
                  style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: theme.dividerColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _birthDate != null
                            ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                            : 'Selecciona tu fecha de nacimiento',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _birthDate != null
                              ? theme.colorScheme.onSurface
                              : theme.hintColor,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
    );
  }

  Widget _buildAddressStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título
          Text(
            'Dirección de Residencia',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Agrega al menos una dirección de residencia',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24.0),
          
          // Lista de direcciones guardadas
          ..._addresses.map((address) => _buildAddressCard(theme, address)).toList(),
          
          // Formulario de dirección
          AddressForm(
            onSave: (address) {
              setState(() {
                _addresses.add(address);
              });
            },
            onCancel: () {
              // No es necesario hacer nada al cancelar
            },
          ),
        ],
      ),
    );
  }
  
  // Construir tarjeta de dirección guardada
  Widget _buildAddressCard(ThemeData theme, AddressEntity address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 20),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Dirección ${_addresses.indexOf(address) + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    // TODO: Implementar edición de dirección
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _addresses.remove(address);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(address.formattedAddress),
            if (address.isPrimary) ...[
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4.0),
                  Text(
                    'Dirección principal',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título
          Text(
            'Confirmar Información',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Revisa que toda la información sea correcta antes de continuar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32.0),

          // Información Personal
          _buildSectionCard(
            theme: theme,
            title: 'Información Personal',
            icon: Icons.person,
            children: [
              _buildInfoRow(
                theme: theme,
                label: 'Nombre completo',
                value: '${_firstNameController.text} ${_lastNameController.text}',
              ),
              const SizedBox(height: 12.0),
              _buildInfoRow(
                theme: theme,
                label: 'Fecha de nacimiento',
                value: _birthDate != null
                    ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                    : 'No especificada',
              ),
              const SizedBox(height: 12.0),
              _buildInfoRow(
                theme: theme,
                label: 'Edad',
                value: _birthDate != null
                    ? '${(DateTime.now().difference(_birthDate!).inDays / 365).floor()} años'
                    : 'No calculada',
              ),
            ],
          ),

          const SizedBox(height: 24.0),

          // Direcciones
          _buildSectionCard(
            theme: theme,
            title: 'Direcciones (${_addresses.length})',
            icon: Icons.location_on,
            children: _addresses.isEmpty
                ? [
                    Text(
                      'No hay direcciones registradas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : _addresses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final address = entry.value;
                    return _buildConfirmationAddressCard(theme, address, index);
                  }).toList(),
          ),

          const SizedBox(height: 32.0),

          // Mensaje de confirmación
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    'Al confirmar, se creará tu cuenta con la información proporcionada.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading) ...[
            const SizedBox(height: 24.0),
            const Center(
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Text(
                'Guardando información...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Construir tarjeta de sección
  Widget _buildSectionCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12.0),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...children,
          ],
        ),
      ),
    );
  }

  // Construir fila de información
  Widget _buildInfoRow({
    required ThemeData theme,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  // Construir tarjeta de dirección en confirmación
  Widget _buildConfirmationAddressCard(ThemeData theme, AddressEntity address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Dirección ${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (address.isPrimary) ...[
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4.0),
                      Text(
                        'Principal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            address.formattedAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildNavigationButtons(ThemeData theme) {
    return Padding(


      padding: const EdgeInsets.all(24.0),
      child: Column(



      children: [
          // Botón principal (Siguiente/Confirmar)
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: _isLoading 
                  ? 'Guardando...' 
                  : (_currentStep < _totalSteps - 1 ? 'Continuar' : 'Confirmar'),
              onPressed: (_isNextButtonEnabled && !_isLoading) ? _onStepContinue : null,
              enabled: _isNextButtonEnabled && !_isLoading,
            ),
          ),
          
          // Botón de regresar (solo si no es el primer paso)
          if (_currentStep > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Regresar',
                onPressed: widget.onRemove ?? () {}, // Fixing callback type issue
                backgroundColor: Colors.transparent,
                textColor: theme.colorScheme.onSurfaceVariant,
                borderColor: theme.dividerColor,
              ),
            ),
  
    

          ]

        ]
      
    )

    );


  }
}
