import 'dart:convert';

import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;
  static SharedPrefs? _prefs;

  static Future<SharedPrefs?> getInstance() async {
    if (_prefs == null) {
      SharedPrefs placeholder = SharedPrefs();
      await placeholder.init();
      _prefs = placeholder;
    }
    return _prefs;
  }

  Future<void> removedata(String key) async {
    await _sharedPrefs!.remove(key);
  }

  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> saveString(String key, String value) async {
    await _sharedPrefs!.setString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await _sharedPrefs!.setInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await _sharedPrefs!.setDouble(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    await _sharedPrefs!.setBool(key, value);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await _sharedPrefs!.setStringList(key, value);
  }

  String readString(String key, {String? def}) {
    return _sharedPrefs!.getString(key) ?? def!;
  }

  int readInt(String key, {int? def}) {
    return _sharedPrefs!.getInt(key) ?? def!;
  }

  double readDouble(String key, {double? def}) {
    return _sharedPrefs!.getDouble(key) ?? def!;
  }

  bool readBool(String key, {bool? def}) {
    return _sharedPrefs!.getBool(key) ?? def!;
  }

  List<String> readStringList(String key, {List<String>? def}) {
    return _sharedPrefs!.getStringList(key) ?? def!;
  }

  
  // Future<void> saveCurrentSong(Track value) async {
  //   await saveString(NOWPLAYING, jsonEncode(value.toMap()));
  // }

  // Track? getCurrentSong() {
    // if (readString(NOWPLAYING, ) != null)
  //   //   return Track.fromMap(jsonDecode(readString(NOWPLAYING)));
  //   // return null;
  // // }

  // //list of music
  // Future<void> setmusicList(List<Track> value) async {
  //   List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
  //   await saveStringList(MUSICLIST, list);
  // }

  // List<Track> getmusicList() {
  //   List<String> json = readStringList(MUSICLIST, def: []);
  //   return json.map((e) => Track.fromMap(jsonDecode(e))).toList();
  // }

  // //list of artist
  // Future<void> setartistList(List<Artist> value) async {
  //   List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
  //   await saveStringList(ARTISTLIST, list);
  // }

  // List<Artist> getartistList() {
  //   List<String> json = readStringList(ARTISTLIST, def: []);
  //   return json.map((e) => Artist.fromMap(jsonDecode(e))).toList();
  // }

  // //list of album
  // Future<void> setalbumList(List<Album> value) async {
  //   List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
  //   await saveStringList(ALBUMLIST, list);
  // }

  // List<Album> getalbumList() {
  //   List<String> json = readStringList(ALBUMLIST,def: []);
  //   return json.map((e) => Album.fromMap(jsonDecode(e))).toList();
  // }

  // Future<void> setfavorites(List<Track> value) async {
  //   List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
  //   await saveStringList(FAVORITES, list);
  // }

  // List<Track> getfavorites() {
  //   List json = readStringList(FAVORITES,def: []);
  //   return json.map((e) => Track.fromMap(jsonDecode(e))).toList();
  // }
}
  // //list of recently Played
  // set recentlyPlayed(Set<String> value) {
  //   List list = value.toList();
  //   _sharedPrefs.setStringList('recently_played', list);
  // }

  // Set<String> get recentlyPlayed {
  //   List<dynamic> json = _sharedPrefs.getStringList('recently_played');
  //   return json?.toSet() ?? {};
  // }