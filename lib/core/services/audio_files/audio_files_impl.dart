import 'dart:convert';

import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';

import 'package:music_player/core/models/artists.dart';

import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/utils/class_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'audio_files.dart';

class AudioFilesImpl implements IAudioFiles {
  OnAudioQuery _query = OnAudioQuery();
  SharedPrefs _prefs = locator<SharedPrefs>();
  List<Track>? _songs;
  late List<Album> _albums;
  late List<Artist> _artists;
  @override
  List<Album> get albums => _albums;

  @override
  // TODO: implement artists
  List<Artist> get artists => _artists;

  @override
  Future<void> fetchAlbums() async {
    // TODO: implement fetchAlbums
  }

  @override
  Future<void> fetchArtists() async {
    // TODO: implement fetchArtists
  }

  @override
  Future<void> fetchMusic() async {
    List<SongModel> res = await _query.querySongs();
    _songs = res.map((e) => ClassUtil.toTrack(e, res.indexOf(e))).toList();
    _prefs.saveStringList(
        MUSICLIST, _songs!.map((e) => jsonEncode((e.toMap()))).toList());
  }

  @override
  // TODO: implement songs
  List<Track> get songs => _prefs
      .readStringList(MUSICLIST)
      .map((e) => Track.fromMap(jsonDecode(e)))
      .toList();
}
