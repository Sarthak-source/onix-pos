import 'package:get_it/get_it.dart';
import 'package:onix_pos/core/localizations/cubit/localization_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
void initGetIt() {
  /// Network Injection
  // Call the async method to get Dio instance

  /// BLoC
  getIt.registerFactory<LocalizationCubit>(() => LocalizationCubit());

  ///* Auth Injection

  /// SharedPreferences
  var registerSingletonAsync = getIt.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());

  /// Validator
}
