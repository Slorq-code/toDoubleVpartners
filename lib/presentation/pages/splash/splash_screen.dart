import 'dart:async';
import 'package:flutter/material.dart';
import 'package:to_double_v_partners/presentation/helpers/animation_helper.dart';
import 'package:to_double_v_partners/presentation/pages/home/home_screen.dart';
import 'package:to_double_v_partners/presentation/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Controladores de animación
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  
  // Animaciones
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Controlador para la animación de palpitación
    _pulseController = AnimationHelper.createPulseAnimation(this);
    _pulseAnimation = AnimationHelper.createPulseScaleAnimation(_pulseController);
    
    // Controlador para la animación de entrada
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    
    _fadeAnimation = AnimationHelper.createFadeAnimation(_fadeController);
  }

  Future<void> _initializeApp() async {
    // Simulamos una carga inicial de 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Navegar a la pantalla principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    AnimationHelper.disposeAnimation(_pulseController);
    AnimationHelper.disposeAnimation(_fadeController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo con animación de palpitación
              ScaleTransition(
                scale: _pulseAnimation,
                child: Column(
                  children: [
                    Text(
                      'Double V Partners',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primary.withValues(alpha: 0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
