import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import '../locator.dart';

class AudioControls extends ChangeNotifier {
  List<Track> _songs = locator<SharedPrefs>().musicList;
  AudioPlayer _audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
  AudioPlayerState _state = AudioPlayerState.STOPPED;
  int _index;
  List<String> _recent = [];
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  set songs(List<Track> list) {
    _songs = list;
    notifyListeners();
  }

  set index(int index) {
    _sharedPrefs.currentSong = _songs[index];
    _index = index;
    notifyListeners();
  }

  set state(AudioPlayerState state) {
    _state = state;
    notifyListeners();
  }

  set recent(String song) {
    if (_sharedPrefs.recentlyPlayed != null) {
      if (_sharedPrefs.recentlyPlayed.length < 5) {
        _recent = _sharedPrefs.recentlyPlayed?.toList();
        if (!_sharedPrefs.recentlyPlayed.contains(song)) {
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
          notifyListeners();
        } else {
          _recent.removeWhere((element) => element == song);
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
          notifyListeners();
        }
      } else {
        if (!_sharedPrefs.recentlyPlayed.contains(song)) {
          _recent.removeLast();
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
          notifyListeners();
        } else {
          _recent.removeWhere((element) => element == song);
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
          notifyListeners();
        }
      }
    } else {
      _recent = [];
      _recent.insert(0, song);
      _sharedPrefs.recentlyPlayed = _recent.toSet();
      notifyListeners();
    }
  }

  void setIndex(String id) {
    int songIndex = _songs.indexWhere((element) => element.id == id);
    index = songIndex;
  }

  void toggleFav() {
    List<Track> list = locator<SharedPrefs>().favorites;
    List<Track>fav = list.where((element) => element.id == nowPlaying.id).toList();
    bool checkFav = fav == null || fav.isEmpty ? false : true;
    print(list);
    if (checkFav) {
      list.removeWhere((element) => element.id == nowPlaying.id);
      _sharedPrefs.favorites = list;
    } else {
      list.add(nowPlaying);
      _sharedPrefs.favorites = list;
    }
  }

  Future<void> play() async {
    try {
      state = AudioPlayerState.PLAYING;
      await _audioPlayer.play(_sharedPrefs.currentSong.filePath);
      print(_sharedPrefs.currentSong.index);
      recent = _sharedPrefs.currentSong.index.toString();
      // notifyListeners();
    } catch (e) {
      print('play error: $e');
    }
  }

  Future<void> next() async {
    try {
      if (_sharedPrefs.shuffle)
        index = Random().nextInt(_songs.length);
      else {
        index == _songs.length - 1 ? index = 0 : index += 1;
      }
      await _audioPlayer.stop();
      await play();
    } catch (e) {
      print('next error: $e');
    }
  }

  Future<void> playAndPause() async {
    if (_state == AudioPlayerState.PLAYING) {
      await _audioPlayer.pause();
      state = AudioPlayerState.PAUSED;
    } else if (_state == AudioPlayerState.PAUSED) {
      await _audioPlayer.resume();
      state = AudioPlayerState.PLAYING;
    } else if (_state == AudioPlayerState.COMPLETED ||
        _state == AudioPlayerState.STOPPED) play();
  }

  Future<void> previous() async {
    if (_sharedPrefs.shuffle)
      index = Random().nextInt(_songs.length);
    else {
      index == 0 ? index = _songs.length - 1 : index -= 1;
    }
    play();
  }

  Stream<Track> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield nowPlaying;
    }
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  AudioPlayerState get state => _state;
  List<Track> get songs => _songs;
  int get index => _index;
  Stream<void> get onCompletion => _audioPlayer.onPlayerCompletion;
  Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
  Track get nowPlaying => _sharedPrefs.currentSong;
  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
}
