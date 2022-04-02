import 'dart:io';

import 'package:musicool/app/index.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SplashModel extends BaseModel {
  final _music = locator<IAudioFileService>();
  final _permissions = locator<IPermissionService>();
  final _navigationService = locator<INavigationService>();
  final _sharedPrefs = locator<SharedPrefs>();
  String loadingText = '';

  void initializeApp() async {
    try {
      bool storageAllowed = await _permissions.getStoragePermission();
      if (!storageAllowed) {
        _navigationService.back();
        return;
      }

      if (_music.songs?.isEmpty ?? true) {
        print('WAITING ...');
        await setupLibrary();
      } else {
        print('USING DELAY...');
        await Future.delayed(const Duration(seconds: 2));
        setupLibrary();
      }
      _sharedPrefs.saveBool(ISFIRSTLAUNCH, false);
      _navigateToHome();
    } catch (e) {
      navigateBack();
    }
  }

  Future<bool> setupLibrary() async {
    try {
      loadingText = 'Loading your songs...';
      notifyListeners();

      await _music.fetchMusic();
      loadingText = 'Loading your albums...';
      notifyListeners();

      await _music.fetchAlbums();
      loadingText = 'Loading artists...';
      notifyListeners();

      await _music.fetchArtists();
      return true;
    } catch (e) {
      print('SPLASH SCREEN: $e');
      rethrow;
    }
  }

  Future<bool> showPermissionSheet() async {
    final val = _sharedPrefs.readBool(ISFIRSTLAUNCH, def: true);
    if (val) {
      await Future.delayed(const Duration(milliseconds: 1000));
      return val;
    } else {
      return val;
    }
  }

  void _navigateToHome() {
    _navigationService.offAllNamed(Routes.homeRoute, (route) => route.isFirst);
    _navigationService.offNamed(Routes.homeRoute);
  }

  void navigateBack() => _navigationService.back();

  void closeApp() => exit(0);
}
