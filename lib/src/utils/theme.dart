import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData basicTheme() {
  TextTheme basicTextTheme(TextTheme base) {
    return base.copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
            fontFamily: 'Montserrat',
            fontSize: ItemSize.fontSize(27),
            color: Colors.white),
        headlineMedium: base.headlineMedium!.copyWith(
            fontFamily: 'ProximaNova',
            fontSize: ItemSize.fontSize(24),
            color: Colors.white),
        displaySmall: base.displaySmall!.copyWith(
            fontFamily: 'ProximaNova',
            fontSize: ItemSize.fontSize(14),
            color: Colors.white),
        displayMedium: base.displayMedium!.copyWith(
            fontFamily: 'ProximaNova',
            fontSize: ItemSize.fontSize(56),
            fontWeight: FontWeight.w300,
            color: Colors.grey),
        displayLarge: base.displayLarge!.copyWith(
            fontFamily: 'ProximaNova',
            fontSize: ItemSize.fontSize(14),
            fontWeight: FontWeight.bold,
            letterSpacing: 2.4,
            color: Color(0xff1F8F51)));
  }

  AppBarTheme basicAppBarTheme(AppBarTheme base) {
    return base.copyWith(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: const Color(0xff1F8F51),
          size: ItemSize.iconSize(22),
        ));
  }

  ButtonThemeData basicButtonTheme(ButtonThemeData base) {
    return base.copyWith(
        minWidth: ItemSize.spaceWidth(40),
        buttonColor: const Color(0xff1F8F51),
        disabledColor: const Color(0xff1F8F51).withOpacity(0.5));
  }

  ElevatedButtonThemeData basicElevatedButtonTheme() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      visualDensity: VisualDensity.standard,
      backgroundColor: const Color(0xff1F8F51),
      disabledForegroundColor: const Color(0xff1F8F51).withOpacity(0.38),
      disabledBackgroundColor: const Color(0xff1F8F51).withOpacity(0.12),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ItemSize.radius(12))),
    ));
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
      useMaterial3: true,
      appBarTheme: basicAppBarTheme(base.appBarTheme),
      hintColor: const Color(0xff1F8F51),
      textTheme: basicTextTheme(base.textTheme),
      primaryColor: const Color(0xff1F8F51),
      elevatedButtonTheme: basicElevatedButtonTheme(),
      primaryColorDark: const Color(0xff29865D),
      primaryColorLight: const Color(0xff29865D).withOpacity(0.8),
      colorScheme: const ColorScheme.light(
        primary: Color(0xff1F8F51),
      ).copyWith(
        secondary: const Color(0xff29865D),
      ));
}

class ItemSize {
  static double fontSize(double value) {
    return value.sp;
  }

  static double iconSize(double value) {
    return value.r;
  }

  static double spaceHeight(double value) {
    return value.h;
  }

  static double radius(double value) {
    return value.r;
  }

  static double spaceWidth(double value) {
    return value.w;
  }
}
