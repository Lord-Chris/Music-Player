import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

class HomeModel extends ChangeNotifier {
  AudioControls _controls = locator<AudioControls>();
  int _selected = 0;
  double _start;
  double _end;

  set selected(index) {
    _selected = index;
    notifyListeners();
  }

  set start(double num) {
    _start = num;
  }

  set end(double num) {
    _end = num;
  }

  dragFinished(int num) {
    double diff = num - _end;
    if (diff.isNegative)
      _controls.previous();
    else
      _controls.next();
  }

  onTap(int index) {
    selected = index;
  }

  void onPlayButtonTap() async {
    await _controls.playAndPause();
    notifyListeners();
  }

  // onMusicSwipe() {
  //   _controls.next();
  //   notifyListeners();
  // }

  Stream<Track> test() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield nowPlaying;
    }
  }

  int get selected => _selected;
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
  AudioPlayerState get state => _controls.state;
  Stream<Duration> get stuff => _controls.sliderPosition;
}
