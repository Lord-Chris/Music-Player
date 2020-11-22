import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class SearchModel extends BaseModel {
  static Music _music = locator<IMusic>();
  List<Album> albums = _music.albums;
  List<Artist> artists = _music.artists;
  List<Track> songs = _music.songs;

  void onChanged(text) {
    getTracks(text);
    getArtist(text);
    getAlbum(text);
    notifyListeners();
  }

  void getTracks(String keyword) {
    songs = _music.songs;
    songs = songs
        .where((song) => song.title.toLowerCase().contains(keyword))
        .toList();
  }

  void getAlbum([String keyword]) {
    albums = _music.albums;
    albums = albums
        .where((album) => album.title.toLowerCase().contains(keyword))
        .toList();
  }

  void getArtist(String keyword) {
    artists = _music.artists;
    artists = artists
        .where((artist) => artist.name.toLowerCase().contains(keyword))
        .toList();
  }
}
