import 'package:musicool/app/index.dart';
import 'package:musicool/core/mixins/_mixins.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SearchModel extends BaseModel with BottomSheetMixin {
  static final _music = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();
  late List<Album> albums = [];
  late List<Artist> artists = [];
  late List<Track> songs = [];

  void navigateBack() => _navigationService.back();

  void onTrackTap(Track track, [String? id]) async {
    await _playerService.changeCurrentListOfSongs(id);
    showPlayingBottomSheet(track: track);
  }

  void onArtistTap(Artist artist) {
    final _tracks = _music.songs!
        .where((element) => artist.trackIds!.contains(element.id))
        .toList();
    _navigationService.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, artist],
    );
  }

  void onAlbumTap(Album album) {
    final _tracks = _music.songs!
        .where((element) => album.trackIds!.contains(element.id))
        .toList();
    _navigationService.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, album],
    );
  }

  void onChanged(text, Object? type) {
    if (type == Track) {
      getTracks(text);
    } else if (type == Artist) {
      getArtist(text);
    } else if (type == Album) {
      getAlbum(text);
    } else {
      getTracks(text);
      getArtist(text);
      getAlbum(text);
    }
    notifyListeners();
  }

  void getTracks(String keyword) {
    songs = _music.songs!;
    songs = keyword.isEmpty
        ? []
        : songs
            .where((song) => song.title.toLowerCase().contains(keyword))
            .toList();
  }

  void getAlbum(String keyword) {
    albums = _music.albums!;
    albums = keyword.isEmpty
        ? []
        : albums
            .where((album) => album.title!.toLowerCase().contains(keyword))
            .toList();
  }

  void getArtist(String keyword) {
    artists = _music.artists!;
    artists = keyword.isEmpty
        ? []
        : artists
            .where((artist) => artist.name!.toLowerCase().contains(keyword))
            .toList();
  }
}
