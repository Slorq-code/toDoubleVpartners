import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final ValueChanged<bool>? onTextChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  const InputText({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.onTextChanged,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _hasFocus = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    
    // Inicializar el estado del texto después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onTextChanged != null) {
        widget.onTextChanged!(widget.controller.text.isNotEmpty);
      }
    });
    
    // Escuchar cambios en el controlador
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  void _onTextChanged() {
    if (widget.onTextChanged != null) {
      widget.onTextChanged!(widget.controller.text.isNotEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        // TextField
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: _hasFocus 
                ? theme.primaryColor 
                : theme.dividerColor,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: widget.suffixIcon,
              counterText: '', // Ocultar contador predeterminado
            ),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
