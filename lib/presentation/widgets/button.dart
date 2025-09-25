import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final double iconSpacing;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.width,
    this.height = 50.0,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding,
    this.textStyle,
    this.icon,
    this.iconSpacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: textColor ?? Colors.white,
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledColor ?? Colors.grey.shade200;
            }
            return backgroundColor ?? theme.primaryColor;
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade500;
            }
            return textColor ?? Colors.white;
          }),
          side: MaterialStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: Colors.grey.shade300);
            }
            return borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none;
          }),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: iconSpacing),
                  ],
                  Text(
                    text,
                    style: textStyle ?? defaultStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
