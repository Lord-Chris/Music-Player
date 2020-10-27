import 'dart:convert';

import 'package:music_player/core/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPrefs {
  SharedPreferences _sharedPrefs;
  static SharedPrefs _prefs;

  static Future<SharedPrefs> getInstance() async {
    if (_prefs == null) {
      SharedPrefs placeholder = SharedPrefs();
      await placeholder.init();
      _prefs = placeholder;
    }
    return _prefs;
  }

  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  set shuffle(bool value) => _sharedPrefs.setBool('shuffle', value);
  bool get shuffle => _sharedPrefs.get('shuffle') ?? false;

  set repeat(String value) => _sharedPrefs.setString('repeat', value);
  String get repeat => _sharedPrefs.get('repeat') ?? 'off';

  set isDarkMode(bool value) => _sharedPrefs.setBool('isDarkMode', value);
  bool get isDarkMode => _sharedPrefs.getBool('isDarkMode');

  set currentSong(Track value) {
    _sharedPrefs.setString('now_playing', jsonEncode(value.toMap()));
  }

  Track get currentSong {
    if (_sharedPrefs.getString('now_playing') != null)
      return Track.fromMap(jsonDecode(_sharedPrefs.getString('now_playing')));
    return null;
  }

  //list of music
  set musicList(TrackList value) =>
      _sharedPrefs.setString('music_list', jsonEncode(value.toJson()));

  TrackList get musicList {
    dynamic json = _sharedPrefs.getString('music_list');
    return json != null ? TrackList.fromJson(jsonDecode(json)) : null;
  }

  //list of recently Played
  set recentlyPlayed(Set<String> value) {
    List list = value.toList();
    _sharedPrefs.setStringList('recently_played', list);
  }

  Set<String> get recentlyPlayed {
    List<dynamic> json = _sharedPrefs.getStringList('recently_played');
    return json?.toSet();
  }

  set favorites(List<Track> value) {
    List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
    _sharedPrefs.setStringList('favorites', list);
  }

  List<Track> get favorites {
    List<String> json = _sharedPrefs.getStringList('favorites');
    return json?.map((e) => Track.fromMap(jsonDecode(e)))?.toList() ?? [];
  }
}
