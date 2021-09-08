import 'package:flutter/material.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/permission_sevice/pemission_service.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';
import 'package:music_player/ui/views/home/home.dart';

class SplashModel extends BaseModel {
  IAudioFiles _music = locator<IAudioFiles>();
  IPermissionService _permissions = locator<IPermissionService>();

  void loading(
      BuildContext context, Function loadBox, Function alertBox) async {
    bool isReady = false;
    bool isLoading = false;
    // if (_music.songs.isEmpty) {
      isLoading = await _permissions.getStoragePermission();
      if (isLoading) {
        loadBox();
        print('waiting ....');
        isReady = await setupLibrary();
      }
    // } else {
    //   // _music.setupLibrary();
    //   print('using delay ....');
    //   await Future.delayed(Duration(seconds: 3));
    //   setState();
    //   isReady = true;
    // }

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
