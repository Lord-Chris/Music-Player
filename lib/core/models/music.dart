import 'dart:typed_data';

import 'package:flutter_audio_query/flutter_audio_query.dart';

class Music {
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  List<Uint8List> artworks = [];
  static List<SongInfo> _songs = [];
  static List<AlbumInfo> _albums = [];
  static List<ArtistInfo> _artists = [];
  static List<GenreInfo> _genres = [];

  List<Uint8List> bringArtwork() {
    songsList().then((value) {
      for (SongInfo song in value) {
        _audioQuery
            .getArtwork(type: ResourceType.SONG, id: song.id)
            .then((value) => artworks.add(value));
      }
    });
  }

  Future setupLibrary() async {
    artistList();
    albumList();
    genreList();
    bringArtwork();
    await songsList();
  }

  Future<List<SongInfo>> songsList() async {
    List<SongInfo> _listOfSongs = await _audioQuery.getSongs();
    return _songs = _listOfSongs;
  }

  Future<List<ArtistInfo>> artistList() async {
    List<ArtistInfo> _listOfArtist = await _audioQuery.getArtists();
    return _artists = _listOfArtist;
  }

  Future<List<AlbumInfo>> albumList() async {
    List<AlbumInfo> _list = await _audioQuery.getAlbums();
    return _albums = _list;
  }

  Future<List<GenreInfo>> genreList() async {
    List<GenreInfo> _list = await _audioQuery.getGenres();
    return _genres = _list;
  }

  List<SongInfo> get songs => _songs;
  List<AlbumInfo> get albums => _albums;
  List<ArtistInfo> get artists => _artists;
  List<GenreInfo> get genres => _genres;
}
