import 'package:flutter/material.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/utils/shared_prefs.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/constants/theme.dart';

class ThemeChanger extends ChangeNotifier {
  bool _isDarkMode = locator<SharedPrefs>().readBool(ISDARKMODE,
      def: WidgetsBinding.instance?.window.platformBrightness ==
          Brightness.dark);

  ThemeData get theme => isDarkMode ? kdarkTheme : klightTheme;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
}
