import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';
import 'package:to_double_v_partners/presentation/providers/address_provider.dart';
import 'package:to_double_v_partners/presentation/providers/address_notifier.dart';
import 'package:to_double_v_partners/presentation/widgets/button.dart';
import 'package:to_double_v_partners/presentation/widgets/input_text.dart';
import 'package:to_double_v_partners/presentation/helpers/address_form_helper.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressEntity? initialAddress;
  final Function(AddressEntity)? onSave;
  final Function()? onCancel;

  const AddressForm({
    super.key,
    this.initialAddress,
    this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final AddressFormHelper _helper;
  
  // Controllers
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _otherCountryController;
  late final TextEditingController _otherDepartmentController;
  late final TextEditingController _otherCityController;

  @override
  void initState() {
    super.initState();
    
    // Initialize helper with factory constructor
    _helper = AddressFormHelper.create(
      ref: ref,
      formKey: _formKey,
      initialAddress: widget.initialAddress,
    );
    
    // Get controllers from helper
    _addressLine1Controller = _helper.addressLine1Controller;
    _addressLine2Controller = _helper.addressLine2Controller;
    _otherCountryController = _helper.otherCountryController;
    _otherDepartmentController = _helper.otherDepartmentController;
    _otherCityController = _helper.otherCityController;
    
    // Initialize with existing address if editing
    _helper.initializeWithAddress(widget.initialAddress);
  }

  @override
  void dispose() {
    _helper.disposeControllers();
    super.dispose();
  }

  // Construir el encabezado del formulario
  Widget _buildHeader(AddressFormState state) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blue),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            state.isExpanded 
                ? widget.initialAddress != null 
                    ? 'Editar Dirección' 
                    : 'Nueva Dirección' 
                : 'Agregar Dirección',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (state.isExpanded)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (widget.onCancel != null) {
                widget.onCancel!();
              } else {
                _helper.toggleExpanded();
              }
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _helper.toggleExpanded();
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressFormProvider);
    
    // Limpiar controladores cuando se cambia el tipo de país
    ref.listen<AddressFormState>(addressFormProvider, (previous, current) {
      if (previous?.isColombia != current.isColombia) {
        _helper.handleCountryTypeChange(current.isColombia);
      }
    });
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(state),
          if (state.isExpanded) ..._buildFormFields(state, context),
        ],
      ),
    );
  }

  // Build form fields
  List<Widget> _buildFormFields(AddressFormState state, BuildContext context) {
    return [
      const SizedBox(height: 16.0),
      _buildCountrySelector(state),
      
      // Show appropriate fields based on country selection
      if (state.isColombia) ..._buildColombiaFields(state),
      if (!state.isColombia) ..._buildInternationalFields(),
      
      // Address line 1 (required)
      const SizedBox(height: 16.0),
      const Text('Dirección principal', 
        style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0),
      InputText(
        label: 'Dirección principal',
        placeholder: 'Ingresa la dirección principal',
        controller: _addressLine1Controller,
        onTextChanged: (hasText) => _helper.updateAddressLine1(),
      ),
      
      // Address line 2 (optional)
      const SizedBox(height: 16.0),
      const Text('Complemento de dirección',
        style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0),
      InputText(
        label: 'Complemento (opcional)',
        placeholder: 'Ej: Apartamento, piso, torre, etc.',
        controller: _addressLine2Controller,
        onTextChanged: (hasText) => _helper.updateAddressLine2(),
      ),
      
      // Save button
      const SizedBox(height: 24.0),
      CustomButton(
        text: 'Guardar dirección',
        onPressed: state.isFormValid ? () => _saveAddress() : null,
      ),
      const SizedBox(height: 16.0),
    ];
  }
  
  // Country selector (Colombia/Other)
  Widget _buildCountrySelector(AddressFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('País', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Row(
          children: [
            _buildCountryOption(
              isColombia: true,
              label: 'Colombia',
              isSelected: state.isColombia,
            ),
            const SizedBox(width: 16.0),
            _buildCountryOption(
              isColombia: false,
              label: 'Otro',
              isSelected: !state.isColombia,
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  // Build country option (Colombia/Other)
  Widget _buildCountryOption({
    required bool isColombia,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _helper.toggleCountryType(isColombia),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? Colors.blue : Colors.grey,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construir campos para direcciones en Colombia
  List<Widget> _buildColombiaFields(AddressFormState state) {
    return [
      _buildDepartmentDropdown(state),
      if (state.department != null) _buildCityDropdown(state),
    ];
  }

  // Construir dropdown de departamentos
  Widget _buildDepartmentDropdown(AddressFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Text('Departamento', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _helper.getValidDropdownValue(state.department, state.departments),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: 'Selecciona un departamento',
          ),
          items: state.departments.isNotEmpty
              ? state.departments.map((dept) => DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  )).toList()
              : [const DropdownMenuItem(value: null, child: Text('Cargando...'))],
          onChanged: (value) {
            if (value != null) {
              _helper.updateDepartment(value);
            }
          },
        ),
      ],
    );
  }

  // Construir dropdown de ciudades
  Widget _buildCityDropdown(AddressFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Text('Ciudad', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _helper.getValidDropdownValue(state.city, state.cities),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: 'Selecciona una ciudad',
          ),
          items: state.cities.isNotEmpty
              ? state.cities.map((city) => DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  )).toList()
              : [const DropdownMenuItem(value: null, child: Text('Selecciona un departamento'))],
          onChanged: (value) {
            if (value != null) {
              _helper.updateCity(value);
            }
          },
        ),
      ],
    );
  }

  // Construir campos para direcciones internacionales
  List<Widget> _buildInternationalFields() {
    return [
      const SizedBox(height: 16.0),
      const Text('País', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0),
      InputText(
        label: 'País',
        placeholder: 'Ingresa el país',
        controller: _otherCountryController,
        onTextChanged: (hasText) => _helper.updateCountry(),
      ),
      
      const SizedBox(height: 16.0),
      const Text('Departamento/Estado', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0),
      InputText(
        label: 'Departamento o estado',
        placeholder: 'Ingresa el departamento o estado',
        controller: _otherDepartmentController,
        onTextChanged: (hasText) => _helper.updateInternationalDepartment(),
      ),
      
      const SizedBox(height: 16.0),
      const Text('Ciudad', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8.0),
      InputText(
        label: 'Ciudad',
        placeholder: 'Ingresa la ciudad',
        controller: _otherCityController,
        onTextChanged: (hasText) => _helper.updateInternationalCity(),
      ),
    ];
  }


  // Método para guardar la dirección
  void _saveAddress() {
    _helper.saveAddress(
      initialAddress: widget.initialAddress,
      onSave: widget.onSave,
    );
  }

  // Método público para editar una dirección desde el exterior
  void editAddress(AddressEntity address) {
    _helper.expandForEdit(address);
  }
}