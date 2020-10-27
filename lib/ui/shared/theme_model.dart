import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/theme.dart';

class ThemeChanger extends ChangeNotifier {
  bool _isDarkMode;

  ThemeData _theme;
  ThemeData get theme =>
      isDarkMode ?
      kdarkTheme : klightTheme;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
  bool get isDarkMode=>locator<SharedPrefs>().isDarkMode ?? WidgetsBinding.instance.window.platformBrightness == Brightness.dark?? false;
}
