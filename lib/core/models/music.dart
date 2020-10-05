import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/track.dart';

class Music {
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  static List<Track> _songs = [];
  static List<AlbumInfo> _albums = [];
  static List<ArtistInfo> _artists = [];
  static List<GenreInfo> _genres = [];

  Future setupLibrary() async {
    await songsList();
    artistList();
    albumList();
    genreList();
  }

  Track convertToTrack(SongInfo song) {
    return Track(
      id: song.id,
      title: song.title,
      album: song.album,
      artist: song.artist,
      artWork: song.albumArtwork,
      displayName: song.displayName,
      duration: song.duration,
      size: song.fileSize,
      filePath: song.filePath,
    );
  }

  Future<void> songsList() async {
    List<SongInfo> _listOfSongs =
        await _audioQuery.getSongs(sortType: SongSortType.DISPLAY_NAME);
    _songs = _listOfSongs.map((song) => convertToTrack(song)).toList();
    // _songs = _listOfSongs;
  }

  void artistList() async {
    List<ArtistInfo> _listOfArtist = await _audioQuery.getArtists();
    _artists = _listOfArtist;
  }

  void albumList() async {
    List<AlbumInfo> _list = await _audioQuery.getAlbums();
    _albums = _list;
  }

  void genreList() async {
    List<GenreInfo> _list = await _audioQuery.getGenres();
    _genres = _list;
  }

  getMusicByArtist(String artist) async {
    return await _audioQuery
        .getSongsFromArtist(artistId: artist)
        .then((value) => value.map((e) => convertToTrack(e)));
  }

  getMusicByAlbum(String album) async {
    return await _audioQuery
        .getSongsFromAlbum(albumId: album)
        .then((value) => value.map((e) => convertToTrack(e)));
  }

  List<Track> get songs => _songs;
  List<AlbumInfo> get albums => _albums;
  List<ArtistInfo> get artists => _artists;
  List<GenreInfo> get genres => _genres;
}
