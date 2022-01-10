import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/viewState.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/core/services/permission_sevice/pemission_service.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SplashModel extends BaseModel {
  IAudioFiles _music = locator<IAudioFiles>();
  IPlayerControls _controls = locator<IPlayerControls>();
  IPermissionService _permissions = locator<IPermissionService>();
  // bool isLoading = false;

  void initializeApp({
    required Function onPermissionError,
    required Function onLibraryError,
    required Function onSuccess,
  }) async {
    bool isReady = false;

    // check storage Permission
    bool storageAllowed = await _permissions.getStoragePermission();
    if (!storageAllowed) return onPermissionError();

    if (_controls.getCurrentListOfSongs().isEmpty) {
      print('WAITING ...');
      setState(ViewState.Busy);
      isReady = await setupLibrary();
    } else {
      print('USING DELAY...');
      await Future.delayed(Duration(seconds: 3));
      setupLibrary();
      isReady = true;
    }
    setState();
    if (!isReady) return onLibraryError();
    onSuccess();
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
