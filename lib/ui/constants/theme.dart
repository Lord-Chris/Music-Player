import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData klightTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
    accentColor: ThemeColors.kPrimary,
    brightness: Brightness.light,
    backgroundColor: ThemeColors.kLightBg,
  ),
  backgroundColor: ThemeColors.kLightBg,
  appBarTheme: AppBarTheme(
    color: ThemeColors.kLightBg,
    iconTheme: IconThemeData().copyWith(color: ThemeColors.kPrimary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.kLightBg,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: ThemeColors.klight,
  ),
  iconTheme: IconThemeData().copyWith(color: ThemeColors.kWhite),
  primaryColor: ThemeColors.klight,
  shadowColor: ThemeColors.kLightBg,
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: ThemeColors.klight),
  primaryTextTheme: TextTheme(
      bodyText2: TextStyle().copyWith(
    color: ThemeColors.kBlack,
  )),
);

ThemeData kdarkTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
    accentColor: ThemeColors.kPrimary,
    brightness: Brightness.dark,
    backgroundColor: ThemeColors.kDarkBg,
  ),
  backgroundColor: ThemeColors.kDarkBg,
  appBarTheme: AppBarTheme().copyWith(color: ThemeColors.kDarkBg),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.kDark,
  ),
  toggleableActiveColor: ThemeColors.kPrimary,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: ThemeColors.klight,
    selectionColor: ThemeColors.kWhite,
  ),
  iconTheme: IconThemeData().copyWith(color: ThemeColors.kWhite),
  primaryColor: ThemeColors.kDark,
  shadowColor: ThemeColors.kDarkShadow,
  primaryTextTheme:
      TextTheme(bodyText2: TextStyle().copyWith(color: ThemeColors.kWhite)),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: ThemeColors.kDark),
);
