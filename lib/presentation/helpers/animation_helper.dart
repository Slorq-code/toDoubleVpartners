import 'package:flutter/material.dart';

class AnimationHelper {
  // Controlador de animación para el efecto de palpitación
  static AnimationController createPulseAnimation(TickerProvider vsync, {
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
    )..repeat(reverse: true);
  }

  // Animación de palpitación (escala)
  static Animation<double> createPulseScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  // Animación de entrada con desvanecimiento
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // Limpieza del controlador de animación
  static void disposeAnimation(AnimationController? controller) {
    controller?.dispose();
  }
}
