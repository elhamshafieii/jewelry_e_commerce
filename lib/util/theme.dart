import 'package:flutter/material.dart';

const defaultTextStyle = TextStyle(fontFamily: 'IranYekan', height: 1.5);

class LightThemeColors {
  static const primaryColor = Colors.deepOrange;
  static const secoundryColor = Color(0xff262a35);
  static const primaryTextColor = Colors.black;
  static const secoundryTextColor = Color(0xffb3b6be);
  static const theritaryTextColor = Color(0xff19BFD3);
  static const backgroundColor = Colors.white;
  static const commentNotOK = Colors.orange;
  static const commentOK = Colors.green;
  static const onSecoundry = Colors.white;
}

final ThemeData appThemeData = ThemeData(
    snackBarTheme: const SnackBarThemeData(
        contentTextStyle: defaultTextStyle,
        backgroundColor: LightThemeColors.secoundryColor),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(defaultTextStyle))),
    dividerTheme:
        DividerThemeData(color: Colors.grey.withOpacity(0.2), thickness: 2),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle:
          defaultTextStyle.copyWith(color: LightThemeColors.secoundryTextColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: LightThemeColors.primaryColor),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: LightThemeColors.primaryTextColor),
      centerTitle: true,
      backgroundColor: LightThemeColors.backgroundColor,
      elevation: 0,
      titleTextStyle: defaultTextStyle.copyWith(
          color: LightThemeColors.primaryTextColor,
          fontSize: 21,
          fontWeight: FontWeight.bold),
    ),
    textTheme: TextTheme(
        labelSmall: defaultTextStyle,
        headlineLarge: defaultTextStyle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: LightThemeColors.primaryTextColor),
        headlineMedium: defaultTextStyle.copyWith(fontSize: 18),
        headlineSmall: defaultTextStyle.copyWith(fontSize: 15),
        bodySmall: defaultTextStyle.copyWith(
            fontSize: 13,
            color: LightThemeColors.primaryTextColor.withOpacity(0.6)),
        bodyMedium: defaultTextStyle.copyWith(
            fontSize: 15,
            color: LightThemeColors.primaryTextColor.withOpacity(0.6),
            fontWeight: FontWeight.bold),
        labelMedium:
            defaultTextStyle.apply(color: LightThemeColors.secoundryTextColor),
        labelLarge:
            defaultTextStyle.apply(color: LightThemeColors.secoundryTextColor)),
    colorScheme: const ColorScheme.light(
        surfaceVariant: Color(0xFFF5F5F5),
        onSecondary: LightThemeColors.onSecoundry,
        background: LightThemeColors.backgroundColor,
        primary: LightThemeColors.primaryColor,
        secondary: LightThemeColors.secoundryColor));
