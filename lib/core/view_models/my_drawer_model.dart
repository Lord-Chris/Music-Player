import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

import '../locator.dart';

class MyDrawerModel extends BaseModel {
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  void toggleShuffle() {
    _sharedPrefs.shuffle = !_sharedPrefs.shuffle;
    notifyListeners();
  }

  void toggleDarkMode() {
    print(_sharedPrefs.isDarkMode);
    _sharedPrefs.isDarkMode = !_sharedPrefs.isDarkMode;
    notifyListeners();
  }

  bool get shuffle => _sharedPrefs.shuffle;
  bool get isDarkMode => _sharedPrefs.isDarkMode;
  String get repeat => _sharedPrefs.repeat;
  Track get nowPlaying => _sharedPrefs.currentSong;
}
