import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/new_controls_utils.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class HomeModel extends BaseModel {
  NewAudioControls _controls = locator<IAudioControls>();
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  int _selected = 2;
  double _end;
  StreamSubscription<PlayerState> subscription;
  bool justOpening = true;

  onModelReady() {
    subscription = _controls.stateStream.listen((event) {});
    subscription.onData((data) async {
      print(data);
      _controls.state = data;
      if (data == PlayerState.stop && !justOpening) {
        if (_sharedPrefs.repeat == 'one') {
          await _controls.playAndPause();
        }
        if (_sharedPrefs.repeat == 'all' &&
            _controls.index == _controls.songs.length - 1) {
          await _controls.next();
        }
        if (_sharedPrefs.repeat == 'off' &&
            _controls.index != _controls.songs.length - 1) {
          await _controls.next();
        }
      }
      justOpening = false;
      notifyListeners();
    });
  }

  onModelFinished() {
    subscription.cancel();
  }

  set selected(index) {
    _selected = index;
    notifyListeners();
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

  // void setState() async {
  //   _controls.stateStream.listen((event) {
  //     _controls.state = event;
  //   }).onData((data) async {
  //     _controls.state = PlayerState.stop;
  //     if (_sharedPrefs.repeat == 'one') {
  //       await _controls.playAndPause();
  //       notifyListeners();
  //     } else if (_sharedPrefs.repeat == 'off' &&
  //         _controls.index == _controls.songs.length - 1) {
  //       return null;
  //     } else {
  //       await _controls.next();
  //       notifyListeners();
  //     }
  //   });
  // }

  // Stream<Track> test() async* {
  //   while (true) {
  //     await Future.delayed(Duration(milliseconds: 500));
  //     yield nowPlaying;
  //   }
  // }

  int get selected => _selected;
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
  // AudioPlayerState get state => _controls.state;
  // Stream<Duration> get stuff => _controls.sliderPosition;
  // Stream<void> get onCompletion => _controls.onCompletion;
}
