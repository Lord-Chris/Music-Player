import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/audio_type.dart';
import 'package:music_player/core/models/track.dart';

import 'package:music_player/core/models/artists.dart';

import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:music_player/core/utils/class_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'audio_files.dart';

class AudioFilesImpl implements IAudioFiles {
  OnAudioQuery _query = OnAudioQuery();
  SharedPrefs _prefs = locator<SharedPrefs>();
  ILocalStorageService _localStorage = locator<ILocalStorageService>();
  List<Track>? _songs;
  List<Album>? _albums;
  List<Artist>? _artists;
  List<Track>? _favorites;

  @override
  Future<void> fetchAlbums() async {
    try {
      List<AlbumModel> res = await _query.queryAlbums();
      _albums = res.map((e) => ClassUtil.toAlbum(e, res.indexOf(e))).toList();

      await Future.forEach(_albums!, (Album _album) async {
        var list = await fetchMusicFrom(AudioType.Album, _album.id!);
        _album.trackIds = list.map((e) => e.id).toList();
        final item = albums?.firstWhere((_e) => _e.id == _album.id);
        if (item == null) return;
        _album.isPlaying = item.isPlaying;
      });
      // DeviceModel device = await _query.queryDeviceInfo();
      // if (device.version > 9)
      //   _albums!.forEach((e) async {
      //     String? art = await fetchArtWorks(int.parse(e.id!), AudioType.Album);
      //     Map<String, dynamic> map = e.toMap();
      //     map['artWork'] = art;
      //     e = Album.fromMap(map);
      //   });

      _localStorage.writeToBox(ALBUMLIST, _albums);
    } catch (e) {
      print('FETCH ALBUM: $e');
      throw e;
    }
  }

  @override
  Future<void> fetchArtists() async {
    try {
      List<ArtistModel> res = await _query.queryArtists();
      _artists = res.map((e) => ClassUtil.toArtist(e, res.indexOf(e))).toList();

      await Future.forEach(_artists!, (Artist _artist) async {
        var list = await fetchMusicFrom(AudioType.Artist, _artist.name!);
        _artist.trackIds = list.map((e) => e.id).toList();
        final item = artists?.firstWhere((_e) => _e.id == _artist.id);
        if (item == null) return;
        _artist.isPlaying = item.isPlaying;
      });

      _localStorage.writeToBox(ARTISTLIST, _artists);
    } catch (e) {
      print('FETCH ARTIST: $e');
      throw e;
    }
  }

  @override
  Future<void> fetchMusic() async {
    try {
      List<SongModel> res = await _query.querySongs();
      _songs = res.map((e) => ClassUtil.toTrack(e, res.indexOf(e))).toList();

      _songs?.forEach((element) {
        Track? _track = songs?.firstWhere((_e) => _e.id == element.id);
        if (_track == null) return;
        element.isPlaying = _track.isPlaying;
      });

      // DeviceModel device = await _query.queryDeviceInfo();
      // if (device.version > 9)
      //   _songs!.forEach((e) async {
      //     String? art = await fetchArtWorks(int.parse(e.id!), AudioType.Track);
      //     Map<String, dynamic> map = e.toMap();
      //     map['artWork'] = art;
      //     e = Track.fromMap(map);
      //   });
      _localStorage.writeToBox(MUSICLIST, _songs);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<Track>> fetchMusicFrom(AudioType type, Object query) async {
    late AudiosFromType _type;

    switch (type) {
      case AudioType.Album:
        _type = AudiosFromType.ALBUM_ID;
        break;
      case AudioType.Artist:
        _type = AudiosFromType.ARTIST;
        break;
      default:
        _type = AudiosFromType.ALBUM_ID;
    }
    List<SongModel> res = await _query.queryAudiosFrom(_type, query);
    return res.map((e) => ClassUtil.toTrack(e, res.indexOf(e))).toList();
  }

  @override
  Future<String?> fetchArtWorks(int id, AudioType type) async {
    late ArtworkType _type;
    switch (type) {
      case AudioType.Track:
        _type = ArtworkType.AUDIO;
        break;
      case AudioType.Album:
        _type = ArtworkType.ALBUM;
        break;
      default:
        _type = ArtworkType.AUDIO;
    }

    Uint8List? art = await _query.queryArtwork(id, _type);
    return art != null ? File.fromRawPath(art).path : null;
  }

  @override
  Future<void> setFavorite(Track song) async {
    _favorites = favorites;
    bool remove = _favorites!.any((e) => e.id == song.id);
    print(remove);
    if (remove) {
      _favorites!.removeWhere((e) => e.id == song.id);
    } else {
      _favorites!.add(song);
    }
    await _prefs.saveStringList(
        FAVORITES, _favorites!.map((e) => jsonEncode(e.toMap())).toList());
  }

  // Getters
  @override
  List<Album>? get albums =>
      _localStorage.getFromBox<List>(ALBUMLIST, def: []).cast<Album>();

  @override
  List<Artist>? get artists =>
      _localStorage.getFromBox<List>(ARTISTLIST, def: []).cast<Artist>();

  @override
  List<Track>? get songs =>
      _localStorage.getFromBox<List>(MUSICLIST, def: []).cast<Track>();

  @override
  List<Track> get currentSongs => _prefs
      .readStringList(CURRENTSONGLIST)
      .map((e) => Track.fromMap(jsonDecode(e)))
      .toList();

  @override
  List<Track> get favorites => _prefs
      .readStringList(FAVORITES)
      .map((e) => Track.fromMap(jsonDecode(e)))
      .toList();
}
