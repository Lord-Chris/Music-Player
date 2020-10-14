import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import '../locator.dart';

class AudioControls extends ChangeNotifier {
  List<Track> _songs = locator<SharedPrefs>().musicList.tracks;
  AudioPlayer _audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
  AudioPlayerState _state;
  int _index;
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

  void setState() {
    _audioPlayer.onPlayerStateChanged.listen((newState) {
      print(state);
      state = newState;
      if (newState == AudioPlayerState.COMPLETED) {
        if (_sharedPrefs.repeat == 'one')
          play();
        else
          next();
      }
    });
  }

  Future<void> play() async {
    try {
      _state = AudioPlayerState.PLAYING;
      await _audioPlayer.play(_sharedPrefs.currentSong.filePath);
      setState();
    } catch (e) {
      print('play error: $e');
    }
  }

  Future<void> next() async {
    try {
      _sharedPrefs.shuffle
          ? index = Random().nextInt(_songs.length)
          : index += 1;
      await _audioPlayer.play(_sharedPrefs.currentSong.filePath);
    } catch (e) {
      print('next error: $e');
    }
  }

  Future<void> playAndPause() async {
    // print(_state);
    // print('state is $state');
    if (_state == AudioPlayerState.PLAYING)
      await _audioPlayer.pause();
    else if (_state == AudioPlayerState.PAUSED)
      await _audioPlayer.resume();
    else if (_state == AudioPlayerState.COMPLETED) play();
  }

  Future<void> previous() async {
    _sharedPrefs.shuffle ? index = Random().nextInt(_songs.length) : index -= 1;
    play();
  }

  // void toggleShuffle() {
  //   _sharedPrefs.shuffle = !_sharedPrefs.shuffle;
  //   notifyListeners();
  // }
  //
  // void toggleRepeat() {
  //   // print('repeat is ${_sharedPrefs.repeat}');
  //   if (_sharedPrefs.repeat == 'off') {
  //     _sharedPrefs.repeat = 'all';
  //     notifyListeners();
  //   } else if (_sharedPrefs.repeat == 'all') {
  //     _sharedPrefs.repeat = 'one';
  //     notifyListeners();
  //   } else {
  //     _sharedPrefs.repeat = 'off';
  //     notifyListeners();
  //   }
  // }

  // ignore: missing_return

  AudioPlayer get audioPlayer => _audioPlayer;
  AudioPlayerState get state => _state;
  List<Track> get songs => _songs;
  int get index => _index;
  Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
  Track get nowPlaying => _sharedPrefs.currentSong;
  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
}
