import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SplashModel extends BaseModel {
  final _music = locator<IAudioFileService>();
  final _appAudioService = locator<IAppAudioService>();
  final _permissions = locator<IPermissionService>();

  void initializeApp({
    required Function onPermissionError,
    required Function onLibraryError,
    required Function onSuccess,
  }) async {
    bool isReady = false;

    // check storage Permission
    bool storageAllowed = await _permissions.getStoragePermission();
    if (!storageAllowed) {
      onPermissionError();
      return;
    }

    if (_appAudioService.currentTrackList.isEmpty) {
      print('WAITING ...');
      setState(ViewState.busy);
      isReady = await setupLibrary();
    } else {
      print('USING DELAY...');
      await Future.delayed(const Duration(seconds: 3));
      setupLibrary();
      isReady = true;
    }
    setState();
    if (!isReady) {
      onLibraryError();
      return;
    }
    onSuccess();
  }

  Future<bool> setupLibrary() async {
    try {
      // await Future.delayed(const Duration(seconds: 3));
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
