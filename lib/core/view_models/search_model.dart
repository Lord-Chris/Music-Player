import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class SearchModel extends BaseModel {
  static Music _music = locator<Music>();
  static SharedPrefs _prefs = locator<SharedPrefs>();
  List<Album> albums = _music.albums;
  List<Artist> artists = _music.artists;
  List<Track> songs = _prefs.musicList;

  void onChanged(text) {
    getTracks(text);
    getArtist(text);
    getAlbum(text);
    notifyListeners();
  }

  void getTracks(String keyword) {
    songs = songs
        .where((song) => song.title.toLowerCase().contains(keyword))
        .toList();
  }

  void getAlbum([String keyword]) {
    albums = albums
        .where((album) => album.title.toLowerCase().contains(keyword))
        .toList();
  }

  void getArtist(String keyword) {
    artists = artists
        .where((artist) => artist.name.toLowerCase().contains(keyword))
        .toList();
  }
}
