
import 'package:flutter/material.dart';
import 'package:onix_pos/core/style/app_colors.dart';


enum AppTheme {
  lightAppTheme,
  darkAppTheme,
}

final appThemeData = {
  AppTheme.darkAppTheme: ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyMedium: const TextStyle().copyWith(color: Colors.white),
      bodyLarge: const TextStyle().copyWith(color: Colors.yellowAccent),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: popOverColor, // Background color for the PopupMenu
    ),
  ),
  AppTheme.lightAppTheme: ThemeData(
    scaffoldBackgroundColor: kPrimaryColor,
    splashColor: Colors.transparent,
    primaryColor: kPrimaryColor,
    popupMenuTheme: const PopupMenuThemeData(
      color: popOverColor, // Background color for the PopupMenu
    ),
    textTheme: TextTheme(
      bodyMedium: const TextStyle().copyWith(color: Colors.white),
      bodyLarge: const TextStyle().copyWith(color: Colors.black),
    ),
  ),
};
