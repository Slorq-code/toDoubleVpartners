import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_double_v_partners/presentation/pages/error/error_page.dart';
import 'package:to_double_v_partners/presentation/pages/splash/splash_screen.dart';
import 'package:to_double_v_partners/presentation/theme/theme.dart' as app_theme;
import 'package:to_double_v_partners/l10n/app_localizations.dart';
import 'firebase_options.dart';

void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  try {


    print('🚀 Inicializando Firebase...');

    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('✅ Firebase inicializado correctamente');
    runApp(const ProviderScope(child: MyApp()));





  } catch (e, stackTrace) {
    print('❌ Error al inicializar Firebase: $e');
    print('📝 Stack trace: $stackTrace');



    
    // Mostrar pantalla de error
    runApp(ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ErrorPage(
          errorMessage: 'Error al inicializar la aplicación: ${e.toString()}',
          onRetry: () => runApp(const ProviderScope(child: MyApp())),
        ),
      ),
    ));
  }
}







class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Double V Partners',
      debugShowCheckedModeBanner: false,
      theme: app_theme.AppTheme.lightTheme,
      // Configuración de localización
      localizationsDelegates: const [
        // Delegados de localización de Flutter
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Nuestro delegado personalizado (al final para permitir sobrescritura)
        AppLocalizations.delegate,
      ],
      // Establecer el idioma predeterminado
      locale: const Locale('es', 'ES'),
      // Idiomas soportados
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],
      // Usar un Builder para asegurar que el contexto esté disponible
      home: Builder(
        builder: (context) {
          // Asegurarse de que las localizaciones estén cargadas
          return Localizations.override(
            context: context,
            locale: const Locale('es', 'ES'),
            child: const SplashScreen(),
          );
        },
      ),
    );
  }
}
