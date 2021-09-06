// // import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:music_player/app/locator.dart';
// import 'package:music_player/core/models/albums.dart';
// import 'package:music_player/core/models/artists.dart';
// import 'package:music_player/core/models/track.dart';
// import 'package:music_player/core/utils/sharedPrefs.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'class_util.dart';

// abstract class IMusic {
//   Future<bool> setupLibrary();
//   Future<bool> getPermissions();
//   Future<void> songsList();
//   Future<void> artistList();
//   Future<void> albumList();
//   Future<List<Track>> getMusicByArtist(String artist);
//   Future<List<Track>> getMusicByAlbum(String album);
// }

// class Music implements IMusic {
//   static Music? music;
//   // FlutterAudioQuery _audioQuery = FlutterAudioQuery();
//   SharedPrefs _prefs = locator<SharedPrefs>();
//   // List<GenreInfo> _genres = [];

//   static Music getInstance() {
//     if (music == null) {
//       Music placeholder = Music();
//       music = placeholder;
//     }
//     return music;
//   }

//   @override
//   Future<bool> setupLibrary() async {
//     try {
//       await getPermissions();
//       await songsList();
//       await artistList();
//       await albumList();
//       // await genreList();
//       return true;
//     } catch (e) {
//       print(e.toString);
//       return false;
//     }
//   }

//   @override
//   Future<bool> getPermissions() async {
//     await Permission.storage.request();
//     if (await Permission.storage.status == PermissionStatus.granted) {
//       return true;
//     }
//     return false;
//   }

//   @override
//   Future<void> songsList() async {
//     try {
//       List<SongInfo> _listOfSongs =
//           await _audioQuery.getSongs(sortType: SongSortType.DEFAULT);
//       await _prefs.setmusicList(_listOfSongs
//           .map((song) => ClassUtil.toTrack(song, _listOfSongs.indexOf(song)))
//           .toList());
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Future<void> artistList() async {
//     try {
//       List<ArtistInfo> _listOfArtist = await _audioQuery.getArtists();
//       await _prefs.setartistList(_listOfArtist
//           .map((artist) =>
//               ClassUtil.toArtist(artist, _listOfArtist.indexOf(artist)))
//           .toList());
//     } catch (e) {
//       print(e.toString());
//       throw Exception('Permission not granted');
//     }
//   }

//   @override
//   Future<void> albumList() async {
//     try {
//       List<AlbumInfo> _list = await _audioQuery.getAlbums();
//       await _prefs.setalbumList(_list
//           .map((album) => ClassUtil.toAlbum(album, _list.indexOf(album)))
//           .toList());
//     } catch (e) {
//       print(e.toString());
//       throw Exception('Permission not granted');
//     }
//   }

//   Future<void> genreList() async {
//     try {
//       List<GenreInfo> _list = await _audioQuery.getGenres();
//       _genres = _list;
//     } catch (e) {
//       print(e.toString());
//       throw Exception('Permission not granted');
//     }
//   }

//   @override
//   Future<List<Track>> getMusicByArtist(String artist) async {
//     return await _audioQuery.getSongsFromArtist(artistId: artist).then(
//         (value) =>
//             value.map((e) => ClassUtil.toTrack(e, value.indexOf(e))).toList());
//   }

//   @override
//   Future<List<Track>> getMusicByAlbum(String album) async {
//     return await _audioQuery.getSongsFromAlbum(albumId: album).then((value) =>
//         value.map((e) => ClassUtil.toTrack(e, value.indexOf(e))).toList());
//   }

//   List<Album> get albums => locator<SharedPrefs>().getalbumList();
//   List<Artist> get artists => locator<SharedPrefs>().getartistList();
//   List<Track> get songs => locator<SharedPrefs>().getmusicList();
//   List<GenreInfo> get genres => _genres;
// }
