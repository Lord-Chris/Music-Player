import 'package:musicool/app/index.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/shared_prefs.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/shared/theme_model.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class AppDrawerModel extends BaseModel {
  final _sharedPrefs = locator<SharedPrefs>();
  final _themeChanger = locator<ThemeChanger>();
  final _playerService = locator<IPlayerService>();
  final _navigationService = locator<INavigationService>();
  final _appAudioService = locator<IAppAudioService>();

  Future<void> toggleShuffle() async {
    await _playerService.toggleShuffle();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await _sharedPrefs.saveBool(ISDARKMODE, !isDarkMode);
    _themeChanger.isDarkMode = _sharedPrefs.readBool(ISDARKMODE);
    notifyListeners();
  }

  void navigateTo(String route, {dynamic data}) {
    _navigationService.back();
    _navigationService.toNamed(route, arguments: data);
  }

  void navigateOff(String route, {dynamic data}) {
    _navigationService.offNamed(route, arguments: data);
  }

  void navigateBack() => _navigationService.back();

  bool get shuffle => _playerService.isShuffleOn;
  bool get isDarkMode =>
      _sharedPrefs.readBool(ISDARKMODE, def: _themeChanger.isDarkMode);
  Repeat get repeat => _playerService.repeatState;
  Track? get nowPlaying => _appAudioService.currentTrack;
}
