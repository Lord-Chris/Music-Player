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

  void toggleRepeat() {
    // print('repeat is ${_sharedPrefs.repeat}');
    if (_sharedPrefs.repeat == 'off') {
      _sharedPrefs.repeat = 'all';
      notifyListeners();
    } else if (_sharedPrefs.repeat == 'all') {
      _sharedPrefs.repeat = 'one';
      notifyListeners();
    } else {
      _sharedPrefs.repeat = 'off';
      notifyListeners();
    }
  }

  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
  Track get nowPlaying => _sharedPrefs.currentSong;
}
