import 'package:musicool/app/index.dart';
import 'package:musicool/core/mixins/_mixins.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class HomeModel extends BaseModel with BottomSheetMixin {
  final _playerService = locator<IPlayerService>();
  final _audioFileService = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();
  final _appAudioService = locator<IAppAudioService>();

  void navigateToSongs() {
    _navigationService.toNamed(Routes.songsRoute);
  }

  void navigateToAlbums() {
    _navigationService.toNamed(Routes.albumsRoute);
  }

  void navigateToArtists() {
    _navigationService.toNamed(Routes.artistsRoute);
  }

  Future<void> onSongItemTap(int index) async {
    await _playerService.changeCurrentListOfSongs();
    showPlayingBottomSheet(track: trackList[index]);
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

  List<Track> get trackList {
    final _tracks = _audioFileService.songs;
    _tracks!.sort((a, b) =>
        (a.displayName.toLowerCase()).compareTo(b.displayName.toLowerCase()));

    return _tracks;
  }

  List<Artist> get artistList => _audioFileService.artists!;
  List<Album> get albumList => _audioFileService.albums!;
  Track? get currentTrack => _appAudioService.currentTrack;
  bool get isPlaying => _playerService.isPlaying;
}
