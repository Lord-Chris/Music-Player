import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class HomeModel extends BaseModel {
  AudioControls _controls = locator<AudioControls>();
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  int _selected = 2;
  // double _start;
  double _end;

  set selected(index) {
    _selected = index;
    notifyListeners();
  }

  // set start(double num) {
  //   _start = num;
  // }

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

  void setState() async {
    _controls.onCompletion.listen((event) {}).onData((data) async {
      _controls.state = AudioPlayerState.COMPLETED;
      if (_sharedPrefs.repeat == 'one') {
        await _controls.play();
        notifyListeners();
      } else if (_sharedPrefs.repeat == 'off' &&
          _controls.index == _controls.songs.length - 1) {
        return null;
      } else {
        await _controls.next();
        notifyListeners();
      }
    });
  }

  Stream<Track> test() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield nowPlaying;
    }
  }

  int get selected => _selected;
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
  AudioPlayerState get state => _controls.state;
  Stream<Duration> get stuff => _controls.sliderPosition;
  Stream<void> get onCompletion => _controls.onCompletion;
}
