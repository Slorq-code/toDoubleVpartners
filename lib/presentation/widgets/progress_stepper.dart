import 'package:flutter/material.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;
  final double indicatorSize;
  final Color activeColor;
  final Color inactiveColor;
  final Color progressColor;
  final Color? textColor;

  const ProgressStepper({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 8.0,
    this.indicatorSize = 24.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.textColor,
  })  : assert(currentStep >= 0 && currentStep < totalSteps,
            'currentStep must be between 0 and totalSteps - 1'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: textColor ?? theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Column(
      children: [
        // Barra de progreso
        Stack(
          children: [
            // Línea de fondo
            Container(
              height: height,
              decoration: BoxDecoration(
                color: inactiveColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // Progreso
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: height,
              width: (currentStep + 1) / totalSteps * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Indicadores de paso
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            return _buildStepIndicator(
              number: index + 1,
              isActive: isActive,
              theme: theme,
              textStyle: textStyle,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepIndicator({
    required int number,
    required bool isActive,
    required ThemeData theme,
    required TextStyle? textStyle,
  }) {
    return Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? activeColor : inactiveColor,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: textStyle?.copyWith(
            color: isActive ? Colors.white : inactiveColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
