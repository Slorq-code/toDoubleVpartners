import 'package:flutter/material.dart';
import 'package:to_double_v_partners/domain/entities/address_entity.dart';
import 'package:to_double_v_partners/presentation/widgets/input_text.dart';

/// ⚠️ DEPRECATED: Este widget está obsoleto.
/// Usar AddressForm con AddressFormHelper en su lugar.
/// 
/// Razones para la deprecación:
/// - No usa el sistema de estado con Riverpod
/// - Lógica duplicada con AddressFormHelper
/// - Incluye código postal (eliminado del sistema)
/// - No sigue la nueva arquitectura de separación de responsabilidades
@Deprecated('Usar AddressForm con AddressFormHelper en su lugar')
class AddressInput extends StatefulWidget {
  final AddressEntity? initialValue;
  final ValueChanged<AddressEntity> onChanged;
  final VoidCallback? onRemove;
  final bool showRemoveButton;

  const AddressInput({
    Key? key,
    this.initialValue,
    required this.onChanged,
    this.onRemove,
    this.showRemoveButton = false,
  }) : super(key: key);

  @override
  State<AddressInput> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;

  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    _addressLine1Controller = TextEditingController(text: widget.initialValue?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: widget.initialValue?.addressLine2 ?? '');
    _cityController = TextEditingController(text: widget.initialValue?.city ?? '');
    _stateController = TextEditingController(text: widget.initialValue?.department ?? '');
    _postalCodeController = TextEditingController(text: widget.initialValue?.postalCode ?? '');
    _countryController = TextEditingController(text: widget.initialValue?.country ?? '');
    _isPrimary = widget.initialValue?.isPrimary ?? false;

    // Agregar listeners a los controladores
    _addressLine1Controller.addListener(_onChanged);
    _addressLine2Controller.addListener(_onChanged);
    _cityController.addListener(_onChanged);
    _stateController.addListener(_onChanged);
    _postalCodeController.addListener(_onChanged);
    _countryController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged(
      (widget.initialValue ?? AddressEntity(
        id: '',
        addressLine1: '',
        country: '',
        department: '',
        city: '',
      )).copyWith(
        id: widget.initialValue?.id ?? '',
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        department: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        isPrimary: _isPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showRemoveButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: widget.onRemove,
                  ),
                ],
              ),
            InputText(
              label: 'Dirección línea 1',
              placeholder: 'Calle y número',
              controller: _addressLine1Controller,
              onTextChanged: (_) => _onChanged(),
            ),
            const SizedBox(height: 12),
            InputText(
              label: 'Dirección línea 2 (opcional)',
              placeholder: 'Departamento, piso, etc.',
              controller: _addressLine2Controller,
              onTextChanged: (_) => _onChanged(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputText(
                    label: 'Ciudad',
                    placeholder: 'Ciudad',
                    controller: _cityController,
                    onTextChanged: (_) => _onChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InputText(
                    label: 'Estado/Región',
                    placeholder: 'Estado o región',
                    controller: _stateController,
                    onTextChanged: (_) => _onChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputText(
                    label: 'Código postal',
                    placeholder: 'Código postal',
                    controller: _postalCodeController,
                    onTextChanged: (_) => _onChanged(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InputText(
                    label: 'País',
                    placeholder: 'País',
                    controller: _countryController,
                    onTextChanged: (_) => _onChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _isPrimary,
                  onChanged: (value) {
                    setState(() {
                      _isPrimary = value ?? false;
                      _onChanged();
                    });
                  },
                ),
                Text(
                  'Dirección principal',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
