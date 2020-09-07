import 'package:flutter_audio_query/flutter_audio_query.dart';

class Music {
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();

  test() async {
    List<SongInfo> stuffs = await _audioQuery.getSongs();
    return stuffs[1].isMusic;
  }

  Future<List<SongInfo>> songsList() async {
    List<SongInfo> _listOfSongs = await _audioQuery.getSongs();
    return _listOfSongs;
  }

  Future<List<ArtistInfo>> artistList() async {
    List<ArtistInfo> _listOfArtist = await _audioQuery.getArtists();
    return _listOfArtist;
  }

  Future<List<AlbumInfo>> albumList() async {
    List<AlbumInfo> _list = await _audioQuery.getAlbums();
    return _list;
  }
}
