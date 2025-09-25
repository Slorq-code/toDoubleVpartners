import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Lista de localizaciones soportadas
  static const List<Locale> supportedLocales = [
    Locale('es', 'ES'),
    Locale('en', 'US'),
  ];

  // Mensajes en diferentes idiomas
  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'appTitle': 'Double V Partners',
      'register': 'Registro',
      'name': 'Nombre',
      'email': 'Correo electrónico',
      'birthDate': 'Fecha de nacimiento',
      'next': 'Siguiente',
      'back': 'Atrás',
      'submit': 'Enviar',
      'selectDate': 'Seleccionar fecha',
    },
    'en': {
      'appTitle': 'Double V Partners',
      'register': 'Register',
      'name': 'Name',
      'email': 'Email',
      'birthDate': 'Birth Date',
      'next': 'Next',
      'back': 'Back',
      'submit': 'Submit',
      'selectDate': 'Select date',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get birthDate => _localizedValues[locale.languageCode]!['birthDate']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get back => _localizedValues[locale.languageCode]!['back']!;
  String get submit => _localizedValues[locale.languageCode]!['submit']!;
  String get selectDate => _localizedValues[locale.languageCode]!['selectDate']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Método de ayuda para acceder a las traducciones de forma más sencilla
AppLocalizations tr(BuildContext context) => AppLocalizations.of(context)!;
