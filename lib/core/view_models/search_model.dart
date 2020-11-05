import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class SearchModel extends BaseModel {
  Music _music = locator<Music>();
  SharedPrefs _prefs = locator<SharedPrefs>();
  List<Album> albums;
  List<Artist> artists;
  List<Track> songs;

  void onChanged(text) {
    getTracks(text);
    getArtist(text);
    getAlbum(text);
    notifyListeners();
  }

  void getTracks(String keyword) {
    List<Track> _songs = _prefs.musicList;
    songs = _songs.where((song) => song.title.toLowerCase().contains(keyword)).toList();
  }

  void getAlbum([String keyword]) {
    List<Album> _albums = _music.albums;
    _albums = _albums
        .where(
            (album) => album.title.toLowerCase().contains(keyword) || album.title.toLowerCase() == keyword)
        .toList();
    albums = _albums;
  }

  void getArtist(String keyword) {
    List<Artist> _artists = _music.artists;
    artists =
        _artists.where((artist) => artist.name.toLowerCase().contains(keyword)).toList();
  }
}
