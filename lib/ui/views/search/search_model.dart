import 'package:musicool/app/locator.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SearchModel extends BaseModel {
  static final _music = locator<IAudioFileService>();
  late List<Album> albums = _music.albums!;
  late List<Artist> artists = _music.artists!;
  late List<Track> songs = _music.songs!;

  void onChanged(text) {
    getTracks(text);
    getArtist(text);
    getAlbum(text);
    notifyListeners();
  }

  void getTracks(String keyword) {
    songs = _music.songs!;
    songs = songs
        .where((song) => song.title!.toLowerCase().contains(keyword))
        .toList();
  }

  void getAlbum(String keyword) {
    albums = _music.albums!;
    albums = albums
        .where((album) => album.title!.toLowerCase().contains(keyword))
        .toList();
  }

  void getArtist(String keyword) {
    artists = _music.artists!;
    artists = artists
        .where((artist) => artist.name!.toLowerCase().contains(keyword))
        .toList();
  }
}
