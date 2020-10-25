import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData primaryMaterialTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.light,
  // accentColor: ThemeColors.kPrimary,
  backgroundColor: ThemeColors.kLightBg,
  appBarTheme: AppBarTheme(color: ThemeColors.kLightBg),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.kLightBg,
  ),
  cursorColor: ThemeColors.klight,
  iconTheme: IconThemeData().copyWith(color: ThemeColors.kWhite),
  primaryColor: ThemeColors.klight,
  shadowColor: ThemeColors.kLightBg,
  primaryTextTheme: TextTheme(
      bodyText2: TextStyle().copyWith(
    color: ThemeColors.kBlack,
  )),
);

ThemeData darkMaterialTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.dark,
  accentColor: ThemeColors.kPrimary,
  backgroundColor: ThemeColors.kDarkBg,
  appBarTheme: AppBarTheme().copyWith(color: ThemeColors.kDarkBg),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ThemeColors.kDark,
  ),
  cursorColor: ThemeColors.kDark,
  iconTheme: IconThemeData().copyWith(color: ThemeColors.kWhite),
  primaryColor: ThemeColors.kDark,
  shadowColor: ThemeColors.kDarkShadow,
  textSelectionColor: ThemeColors.kWhite,
  primaryTextTheme:
      TextTheme(bodyText2: TextStyle().copyWith(color: ThemeColors.kWhite)),
);
