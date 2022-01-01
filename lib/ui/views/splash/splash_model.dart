import 'package:flutter/material.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:musicool/core/services/permission_sevice/pemission_service.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';
import 'package:musicool/ui/views/home/home.dart';

class SplashModel extends BaseModel {
  IAudioFiles _music = locator<IAudioFiles>();
  IPlayerControls _controls = locator<IPlayerControls>();
  IPermissionService _permissions = locator<IPermissionService>();
  bool isLoading = false;

  void loading(BuildContext context, Function alertBox) async {
    await locator<ILocalStorageService>().clearBox();
    bool isReady = false;
    if (_controls.getCurrentListOfSongs().isEmpty) {
      isLoading = await _permissions.getStoragePermission();
      if (isLoading) {
        // showLoader = true;
        notifyListeners();
        print('waiting ....');
        isReady = await setupLibrary();
      }
    } else {
      print('USING DELAY...');
      await Future.delayed(Duration(seconds: 3));
      setupLibrary();
      setState();
      isReady = true;
    }

    if (isReady) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    } else {
      alertBox();
    }
  }

  Future<bool> setupLibrary() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      await _music.fetchMusic();
      await _music.fetchAlbums();
      await _music.fetchArtists();
      return true;
    } catch (e) {
      print('SPLASH SCREEN: $e');
      return false;
    }
  }
}
