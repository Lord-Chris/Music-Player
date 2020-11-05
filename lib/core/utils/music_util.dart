import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

class Music {
  static Music _music;
  FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  SharedPrefs _prefs = locator<SharedPrefs>();
  // List<Album> _albums = [];
  // List<Artist> _artists = [];
  List<GenreInfo> _genres = [];

  Future<bool> setupLibrary() async {
    try {
      await songsList();
      await artistList();
      await albumList();
      // await genreList();
      return true;
    } catch (e) {
      print(e.toString);
      return false;
    }
  }

  static Future<Music> init() async {
    if (_music == null) {
      Music placeholder = Music();
      await placeholder.setupLibrary();
      _music = placeholder;
    }
    return _music;
  }

  Track convertToTrack(SongInfo song, int index) {
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
      index: index,
    );
  }

  Album convertToAlbum(AlbumInfo album, int index) {
    return Album(
      id: album.id,
      title: album.title,
      artwork: album.albumArt,
      numberOfSongs: album.numberOfSongs,
      index: index,
    );
  }

  Artist convertToArtist(ArtistInfo artist, int index) {
    return Artist(
      id: artist.id,
      name: artist.name,
      artwork: artist.artistArtPath,
      numberOfSongs: artist.numberOfTracks,
      numberOfAlbums: artist.numberOfAlbums,
      index: index,
    );
  }

  Future<void> songsList() async {
    try {
      List<SongInfo> _listOfSongs =
          await _audioQuery.getSongs(sortType: SongSortType.DEFAULT);
      _prefs.musicList = _listOfSongs
          .map((song) => convertToTrack(song, _listOfSongs.indexOf(song)))
          .toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> artistList() async {
    try {
      List<ArtistInfo> _listOfArtist = await _audioQuery.getArtists();
       _prefs.artistList = _listOfArtist
          .map((artist) =>
              convertToArtist(artist, _listOfArtist.indexOf(artist)))
          .toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Permission not granted');
    }
  }

  Future<void> albumList() async {
    try {
      List<AlbumInfo> _list = await _audioQuery.getAlbums();
       _prefs.albumList = _list
          .map((album) => convertToAlbum(album, _list.indexOf(album)))
          .toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Permission not granted');
    }
  }

  Future<void> genreList() async {
    try {
      List<GenreInfo> _list = await _audioQuery.getGenres();
      _genres = _list;
    } catch (e) {
      print(e.toString());
      throw Exception('Permission not granted');
    }
  }

  Future<List<Track>> getMusicByArtist(String artist) async {
    return await _audioQuery.getSongsFromArtist(artistId: artist).then(
        (value) =>
            value.map((e) => convertToTrack(e, value.indexOf(e))).toList());
  }

  Future<List<Track>> getMusicByAlbum(String album) async {
    return await _audioQuery.getSongsFromAlbum(albumId: album).then((value) =>
        value.map((e) => convertToTrack(e, value.indexOf(e))).toList());
  }

  List<Album> get albums => locator<SharedPrefs>().albumList;
  List<Artist> get artists => locator<SharedPrefs>().artistList;
  List<GenreInfo> get genres => _genres;
}
