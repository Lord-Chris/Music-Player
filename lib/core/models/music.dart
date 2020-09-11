import 'package:flutter_audio_query/flutter_audio_query.dart';

class Music {
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  List<AlbumInfo> albums = [];
  List<ArtistInfo> artists = [];
  List<GenreInfo> genres = [];

  test() async {
    List<PlaylistInfo> stuffs = await _audioQuery.getPlaylists();
    return stuffs[1];
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

  Future<List<GenreInfo>> genreList() async {
    List<GenreInfo> _list = await _audioQuery.getGenres();
    return _list;
  }
}
