import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class HomeModel extends BaseModel {
  final _playerService = locator<IPlayerService>();
  final _audioFileService = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();
  final _appAudioService = locator<IAppAudioService>();

  late StreamSubscription<AppPlayerState> stateSub;

  void navigateToSongs() {
    _navigationService.toNamed(Routes.songsRoute);
  }

  void navigateToAlbums() {
    _navigationService.toNamed(Routes.albumsRoute);
  }

  void navigateToArtists() {
    _navigationService.toNamed(Routes.artistsRoute);
  }

  void onModelReady() {
    // print(_playerService.playerState);
    // if (justOpening && _playerService.playerState == AppPlayerState.Playing) {
    //   (AppPlayerState.Playing);
    //   justOpening = false;
    //   notifyListeners();
    // }
    // stateSub =
    //     _appAudioService.playerStateController.stream.listen((data) async {});
    // stateSub.onData((data) async {
    //   // print("CHANGE OCCUREEDDDD");
    //   List<Track> list;
    //   if (data != _appAudioService.playerState) {
    //     list = _playerService.getCurrentListOfSongs();

    //     if (data == AppPlayerState.Finished) {
    //       if (_playerService.repeatState == Repeat.One) {
    //         await _handler.play();
    //       } else if (_playerService.repeatState == Repeat.All) {
    //         await _handler.skipToNext();
    //       } else if (_playerService.repeatState == Repeat.Off &&
    //           _appAudioService.currentTrack!.index! != list.length - 1) {
    //         await _handler.skipToNext();
    //       }
    //     }
    //   }
    //   notifyListeners();
    // });
  }

  void onModelFinished() {
    //   _playerService.dispose();
    //   stateSub.cancel();
    //   print('Disconnected');
  }

  // set end(double num) {
  //   _end = num;
  // }

  // dragFinished(int num) {
  //   double diff = num - _end;
  //   // if (diff.isNegative)
  //   //   _playerService.playPrevious();
  //   // else
  //   //   _playerService.playNext();
  // }

  Future<void> onSongItemTap(int index) async {
    await _playerService.changeCurrentListOfSongs();
    _navigationService.toNamed(Routes.playingRoute,
        arguments: PlayingData(trackList[index]));
  }

  void onAlbumItemTap(int index) {
    final _tracks = _audioFileService.songs!
        .where((element) => albumList[index].trackIds!.contains(element.id))
        .toList();
    _navigationService.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, albumList[index]],
    );
  }

  void onArtistItemTap(int index) {
    final _tracks = _audioFileService.songs!
        .where((element) => artistList[index].trackIds!.contains(element.id))
        .toList();
    _navigationService.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, artistList[index]],
    );
  }

  void onSearchTap() => _navigationService.toNamed(Routes.searchRoute);

  List<Track> get trackList => _audioFileService.songs!;
  List<Artist> get artistList => _audioFileService.artists!;
  List<Album> get albumList => _audioFileService.albums!;
  Track? get currentTrack => _appAudioService.currentTrack;
  bool get isPlaying => _playerService.isPlaying;
}
