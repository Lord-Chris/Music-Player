import 'dart:convert';

import 'package:music_player/core/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences _sharedPrefs;
  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  set shuffle(bool value) => _sharedPrefs.setBool('shuffle', value);
  bool get shuffle => _sharedPrefs.get('shuffle');

  set repeat(String value) => _sharedPrefs.setString('repeat', value);
  String get repeat => _sharedPrefs.get('repeat');

  set currentSong(Track value) {
    _sharedPrefs.setString('now_playing', jsonEncode(value.toMap()));
  }

  Track get currentSong {
    return Track.fromMap(jsonDecode(_sharedPrefs.getString('now_playing')));
  }

  //list of music
  set musicList(TrackList value) =>
      _sharedPrefs.setString('now_playing', jsonEncode(value.toJson()));

  TrackList get musicList {
    dynamic json = jsonDecode(_sharedPrefs.getString('now_playing'));
    return TrackList.fromJson(json);
  }

  //list of recently Played
  set recentlyPlayed(List<Track> value) {
    _sharedPrefs.setStringList('recently_played',
        value.map((track) => jsonEncode(track.toMap())).toList());
  }

  List<Track> get recentlyPlayed {
    List<dynamic> json = _sharedPrefs
        .getStringList('recently_played')
        .map((e) => jsonDecode(e))
        .toList();
    return json.map((e) => Track.fromMap(e)).toList();
  }
}
