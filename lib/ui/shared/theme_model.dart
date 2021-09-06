import 'package:flutter/material.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:music_player/ui/constants/theme.dart';

class ThemeChanger extends ChangeNotifier {
  bool _isDarkMode = locator<SharedPrefs>().readBool(ISDARKMODE) ??
      WidgetsBinding.instance?.window.platformBrightness == Brightness.dark;

  ThemeData get theme => isDarkMode ? kdarkTheme : klightTheme;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
}
