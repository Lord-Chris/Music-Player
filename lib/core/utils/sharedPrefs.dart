import 'dart:convert';

import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  set musicList(List<Track> value) {
    List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
    _sharedPrefs.setStringList('music_list', list);
  }

  List<Track> get musicList {
    List<String> json = _sharedPrefs.getStringList('music_list');
    return json?.map((e) => Track.fromMap(jsonDecode(e)))?.toList() ?? null;
  }

  //list of artist
  set artistList(List<Artist> value) {
    List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
    _sharedPrefs.setStringList('artist_list', list);
  }

  List<Artist> get artistList {
    List<String> json = _sharedPrefs.getStringList('artist_list');
    return json?.map((e) => Artist.fromMap(jsonDecode(e)))?.toList() ?? [];
  }
  //list of album
  set albumList(List<Album> value) {
    List<String> list = value.map((e) => jsonEncode(e.toMap())).toList();
    _sharedPrefs.setStringList('album_list', list);
  }

  List<Album> get albumList {
    List<String> json = _sharedPrefs.getStringList('album_list');
    return json?.map((e) => Album.fromMap(jsonDecode(e)))?.toList() ?? [];
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
    List json = _sharedPrefs.getStringList('favorites');
    return json?.map((e) => Track.fromMap(jsonDecode(e)))?.toList() ?? [];
  }
}
