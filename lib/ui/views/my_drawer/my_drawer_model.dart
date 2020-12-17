import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:music_player/ui/shared/theme_model.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class MyDrawerModel extends BaseModel {
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  ThemeChanger _themeChanger = locator<ThemeChanger>();

  Future<void> toggleShuffle() async {
    await _sharedPrefs.saveBool(SHUFFLE,!_sharedPrefs.readBool(SHUFFLE,def: false));
    notifyListeners();
  }

  void toggleDarkMode() {
    _sharedPrefs.isDarkMode = !isDarkMode;
    _themeChanger.isDarkMode = _sharedPrefs.isDarkMode;
    notifyListeners();
  }

  bool get shuffle => _sharedPrefs.readBool(SHUFFLE,def: false);
  bool get isDarkMode => _sharedPrefs.isDarkMode ?? _themeChanger.isDarkMode;
  String get repeat => _sharedPrefs.repeat;
  Track get nowPlaying => _sharedPrefs.currentSong;
}
