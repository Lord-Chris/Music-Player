import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';
import 'package:music_player/ui/shared/theme_model.dart';

import '../locator.dart';

class MyDrawerModel extends BaseModel {
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  ThemeChanger _themeChanger = locator<ThemeChanger>();

  void toggleShuffle() {
    _sharedPrefs.shuffle = !_sharedPrefs.shuffle;
    notifyListeners();
  }

  void toggleDarkMode() {
    _sharedPrefs.isDarkMode = !isDarkMode;
    _themeChanger.isDarkMode = _sharedPrefs.isDarkMode;
    notifyListeners();
  }

  bool get shuffle => _sharedPrefs.shuffle;
  bool get isDarkMode => _sharedPrefs.isDarkMode ?? _themeChanger.isDarkMode;
  String get repeat => _sharedPrefs.repeat;
  Track get nowPlaying => _sharedPrefs.currentSong;
}
