import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/injection/injector.dart';
import 'package:onix_pos/core/localizations/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInit(const Locale('ar')));

  String lang = 'ar';

  static LocalizationCubit get(context) =>
      BlocProvider.of<LocalizationCubit>(context);

  // Getter to retrieve the current locale
  Locale get currentLocale => state.locale;

  void loadInitialLocale() async {
    final locale = getIt<SharedPreferences>().getString("locale");
    // print("localeText =======>>>>>>>>> ${localeText.t}");
    if (locale != null) {
      if (locale == AppLocalization.supportedLocales.first.toString()) {
        lang = "ar";
        emit(LocalizationChange(AppLocalization.supportedLocales.first));
      } else if (locale == AppLocalization.supportedLocales.last.toString()) {
        lang = "en";
        emit(LocalizationChange(AppLocalization.supportedLocales.last));
      }
    }
  }

  // Function to change the language
  Future<void> changeLanguage(String newLang) async {
    lang = newLang;
    if (newLang == "ar") {
      getIt<SharedPreferences>().setString(
          "locale", AppLocalization.supportedLocales.first.toString());
      emit(LocalizationChange(AppLocalization.supportedLocales.first));
    } else {
      getIt<SharedPreferences>().setString(
          "locale", AppLocalization.supportedLocales.last.toString());
      emit(LocalizationChange(AppLocalization.supportedLocales.last));
    }
  }
}
