import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/core/utils/sharedPrefs.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/shared/theme_model.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class MyDrawerModel extends BaseModel {
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  ThemeChanger _themeChanger = locator<ThemeChanger>();
  IPlayerControls _player = locator<IPlayerControls>();

  Future<void> toggleShuffle() async {
    await _player.toggleShuffle();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await _sharedPrefs.saveBool(ISDARKMODE, !isDarkMode);
    _themeChanger.isDarkMode = _sharedPrefs.readBool(ISDARKMODE);
    notifyListeners();
  }

  bool get shuffle => _player.isShuffleOn;
  bool get isDarkMode =>
      _sharedPrefs.readBool(ISDARKMODE, def: _themeChanger.isDarkMode);
  Repeat get repeat => _player.repeatState;
  Track? get nowPlaying => _player.getCurrentTrack();
}
