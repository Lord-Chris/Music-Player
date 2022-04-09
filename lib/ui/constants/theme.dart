import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData klightTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
    accentColor: AppColors.main,
    brightness: Brightness.light,
    backgroundColor: AppColors.white,
  ),
  backgroundColor: AppColors.white,
  cardColor: AppColors.white,
  indicatorColor: AppColors.darkMain,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.lightMain,
  ),
  iconTheme: const IconThemeData().copyWith(color: AppColors.main),
  primaryColor: AppColors.main,
  // shadowColor: ThemeColors.kLightBg,
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: AppColors.main),
);

// ThemeData kdarkTheme = ThemeData(
//   primarySwatch: Colors.purple,
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.fromSwatch(
//     primarySwatch: Colors.purple,
//     accentColor: ThemeColors.kPrimary,
//     brightness: Brightness.dark,
//     backgroundColor: ThemeColors.kDarkBg,
//   ),
//   backgroundColor: ThemeColors.kDarkBg,
//   appBarTheme: const AppBarTheme().copyWith(color: ThemeColors.kDarkBg),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     backgroundColor: ThemeColors.kDark,
//   ),
//   toggleableActiveColor: ThemeColors.kPrimary,
//   textSelectionTheme: const TextSelectionThemeData(
//     cursorColor: ThemeColors.klight,
//     selectionColor: ThemeColors.kWhite,
//   ),
//   iconTheme: const IconThemeData().copyWith(color: ThemeColors.kWhite),
//   primaryColor: ThemeColors.kDark,
//   shadowColor: ThemeColors.kDarkShadow,
//   primaryTextTheme: TextTheme(
//       bodyText2: const TextStyle().copyWith(color: ThemeColors.kWhite)),
//   bottomSheetTheme:
//       const BottomSheetThemeData(backgroundColor: ThemeColors.kDark),
// );
