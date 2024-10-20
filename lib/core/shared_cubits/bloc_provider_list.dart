import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_pos/core/localizations/cubit/localization_cubit.dart';

import 'responsive_cubite/responsive_cubit.dart';

class BlocProviderList {
  static List<BlocProvider> getProviders(BuildContext context) {
    return [
      BlocProvider<LocalizationCubit>(
        create: (_) => LocalizationCubit()..loadInitialLocale(),
      ),
      BlocProvider<ResponsiveCubit>(
        create: (_) => ResponsiveCubit(),
      ),
    ];
  }
}
