part of 'localization_cubit.dart';

abstract class LocalizationState {
  LocalizationState(this.locale);
  final Locale locale;
}

class LocalizationInit extends LocalizationState {
  LocalizationInit(Locale initialLocale) : super(initialLocale);
}

class LocalizationChange extends LocalizationState {
  LocalizationChange(Locale newLocale) : super(newLocale);
}
