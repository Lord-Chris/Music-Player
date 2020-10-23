import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/base_model.dart';

class SearchModel extends BaseModel {
  Music _music = Music();

  void onChanged() {
    notifyListeners();
  }

  Future<List<Track>> getMusic(String keyword) async {
    return await _music.searchMusic(keyword);
  }

  Future<List<AlbumInfo>> getAlbum(String keyword) async {
    return _music.searchAlbum(keyword);
  }

  Future<List<ArtistInfo>> getArtist(String keyword) async {
    return await _music.searchArtist(keyword);
  }
  //  List<AlbumInfo> getAlbum(String keyword) {
  //   List<AlbumInfo> albums = [];
  //   _music.albums.forEach((album) {
  //     if (album.title.startsWith(keyword) || album.title == keyword)
  //       albums.add(album);
  //   });
  //   notifyListeners();
  //   return albums;
  // }
}
