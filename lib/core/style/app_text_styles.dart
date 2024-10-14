import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle styleLight12(context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextFiledColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 12),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w300,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleLight14(context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextFiledColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 14),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w300,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleRegular12(BuildContext context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 12),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleRegular14(BuildContext context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 14),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleMedium12(BuildContext context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 12),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w500,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleMedium14(BuildContext context,
      {double? fontSize,
        Color? color,
        bool underLine = false,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? kTextColor,
        fontSize: getResponsiveFontSize(context, fontSize: fontSize ?? 14),
        fontFamily: 'ReadexPro',
        fontWeight: fontWeight ?? FontWeight.w500,
        decoration: underLine ? TextDecoration.underline : null,
        decorationColor: color);
  }

  static TextStyle styleRegular20(BuildContext context, {Color? color}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleBold20(BuildContext context, {Color? color}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.bold,
    );
  }

// In your AppTextStyles class

  static TextStyle styleRegular16(BuildContext context,
      {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontFamily: 'ReadexPro',
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static TextStyle styleBold32(BuildContext context,
      {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 32),
      fontFamily: 'ReadexPro',
      fontWeight: fontWeight ?? FontWeight.bold,
    );
  }

  static TextStyle styleBold36(BuildContext context,
      {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 36),
      fontFamily: 'ReadexPro',
      fontWeight: fontWeight ?? FontWeight.bold,
    );
  }

  // In your AppTextStyles class

  static TextStyle styleBold24(BuildContext context, {Color? color}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 24),
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleRegular18(BuildContext context,
      {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      color: color ?? kTextColor,
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontFamily: 'ReadexPro',
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}

double getResponsiveFontSize(context, {required double fontSize}) {
  final double scaleFactor = getScaleFactor(context);
  final double responsiveFontSize = fontSize * scaleFactor;

  final double lowerLimit = fontSize * .8;
  final double upperLimit = fontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit).floorToDouble();
}

double getScaleFactor(context) {
  final double width = MediaQuery.of(context).size.width;
  const double minWidth = 550; // Minimum width for scaling
  const double maxWidth = 1920; // Maximum width for scaling

  // Calculate a normalized value between 0 and 1 based on width
  final double normalizedWidth = (width - minWidth) / (maxWidth - minWidth);

  // Use lerp to interpolate between scale factors for different ranges
  final double scaleFactorA = width / 550; // Scale factor for small screens
  final double scaleFactorB =
      width / 1000; // Scale factor for medium screens (around 700)
  final double scaleFactorC = width / 1920; // Scale factor for large screens

  // Interpolate between B and C for smoother transition
  final double lerpedScaleFactor = lerp(scaleFactorB, scaleFactorC, normalizedWidth);

  return lerpedScaleFactor;
}

double lerp(double a, double b, double t) {
  return (1.0 - t) * a + t * b;
}
