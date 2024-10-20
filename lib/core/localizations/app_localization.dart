import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'lang/ar_eg.dart';
import 'lang/en_us.dart';

class AppLocalization {
  AppLocalization._privateConstructor();

  static final AppLocalization _instance = AppLocalization._privateConstructor();

  static AppLocalization get instance => _instance;

  Locale _locale = const Locale('en'); // Default locale

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': arEg,
    'en': enUs,
  };

  // Initialize the locale, typically during app start
  void setLocale(Locale locale) {
    _locale = locale;
  }

  Locale get locale => _locale;

  // Get list of supported locales
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static List<String> languages() => _localizedValues.keys.toList();

  // Get localized string without context
  String getString(String text) =>
      _localizedValues[_locale.languageCode]![text] ?? text;

  // Optional static method to make it easier to access from anywhere
  static String translate(String key) => _instance.getString(key);

  // Static method to access the localization instance via context
  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages().contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    AppLocalization.instance.setLocale(locale); // Set locale here
    return SynchronousFuture<AppLocalization>(AppLocalization.instance);
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

extension LocalizationExtension on String {
  String tr(BuildContext context) {
    // BuildContext context = navigatorKey.currentContext!;
    return AppLocalization.of(context).getString(this);
  }
}