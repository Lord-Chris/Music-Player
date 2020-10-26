import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class SearchModel extends BaseModel {
  Music _music = locator<Music>();
  SharedPrefs _prefs = locator<SharedPrefs>();
  List<AlbumInfo> albums;
  List<ArtistInfo> artists;
  List<Track> songs;

  void onChanged(text) {
    getTracks(text);
    getArtist(text);
    getAlbum(text);
    notifyListeners();
  }

  // Future<List<Track>> getMusic(String keyword) async {
  //   return await _music.searchMusic(keyword);
  // }

  // Future<List<AlbumInfo>> getAlbum(String keyword) async {
  //   return _music.searchAlbum(keyword);
  // }

  // Future<List<ArtistInfo>> getArtist(String keyword) async {
  //   return await _music.searchArtist(keyword);
  // }

  void getTracks(String keyword) {
    List<Track> _songs = _prefs.musicList?.tracks;
    songs = _songs.where((song) => song.title.contains(keyword)).toList();
  }

  void getAlbum([String keyword]) {
    List<AlbumInfo> _albums = _music.albums;
    _albums = _albums
        .where(
            (album) => album.title.contains(keyword) || album.title == keyword)
        .toList();
    albums = _albums;
  }

  void getArtist(String keyword) {
    List<ArtistInfo> _artists = _music.artists;
    artists =
        _artists.where((artist) => artist.name.contains(keyword)).toList();
  }

  // if (album.title.startsWith(keyword) || album.title == keyword)
  //       albums.add(album);
}
