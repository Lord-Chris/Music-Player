import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/viewmodels/base_model.dart';

class PlayingProvider extends BaseModel {
  bool _isPlaying = false;
  double _sliderPosition = 0;
  double _songDuration = 1;
  String _maxDuration = '--:--';
  String _currentDuration = '--:--';
  AudioPlayer _audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');

  void onSliderChange(double val) {
    _sliderPosition = val;
    notifyListeners();
  }

  void onModelReady(String url) {
    _audioPlayer.play(url);
    getDuration();
    getSliderPosition();
    _isPlaying = true;
  }

  void onModelFinished() {
    _audioPlayer.dispose();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void getDuration() {
    _audioPlayer.onDurationChanged.listen((duration) {
      String time = duration.toString();
      int len = time.length;
      if (len == 14 && time[0] != '0')
        return _maxDuration = time.substring(0, len - 7);
      else if (len == 14 && time[0] == '0' && time[3] == '0')
        return _maxDuration = time.substring(3, len - 7);
      else if (len == 14 && time[0] == '0' && time[3] != '0')
        return _maxDuration = time.substring(2, len - 7);
      notifyListeners();
//      print(duration);
    });
    _audioPlayer.onAudioPositionChanged.listen((duration) {
      String time = duration.toString();
      int len = time.length;
      if (len == 14 && time[0] != '0')
        return _currentDuration = time.substring(0, len - 7);
      else if (len == 14 && time[0] == '0' && time[3] == '0')
        return _currentDuration = time.substring(3, len - 7);
      else if (len == 14 && time[0] == '0' && time[3] != '0')
        return _currentDuration = time.substring(2, len - 7);
      notifyListeners();
      print(duration);
    });

//    _audioPlayer.getDuration().then((value) => print('max dur is $value'));
//    String _songDuration;
//    String thing = '1:14:27.301000';
//    int _len = thing.length;
////    0:04:27.301000
//
//    if (thing[0] == '0') {
//      if (thing[_len - 12] == '0')
//        _songDuration = thing.substring((_len - 11), (_len - 7));
//      else
//        _songDuration = thing.substring((_len - 12), (_len - 7));
//    } else {
//      _songDuration = thing.substring(0, (_len - 7));
//    }
//    return _songDuration;
//    print(thing[_len - 12]);
//    String conthing = thing;
//  1:13:27.072000
//    int t = int.parse(duration);
//    var mins = Duration(milliseconds: t).inMinutes % 60;
//    var secs = Duration(milliseconds: t).inSeconds % 60;
////    print('time is $mins:$secs');
//    return '$mins:$secs';
  }

  void getSliderPosition() {
    _audioPlayer.onAudioPositionChanged.listen((duration) {
      _sliderPosition = duration.inMilliseconds.toDouble();
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      _songDuration = duration.inMilliseconds.toDouble();
      notifyListeners();
    });
  }

  void setSliderPosition() {
    var val = _audioPlayer.onSeekComplete;
    val.print(val.toString());
    print(val.runtimeType);
  }

  test() {}

  double get sliderPosition => _sliderPosition;
  bool get isPlaying => _isPlaying;
  double get songDuration => _songDuration;
  String get maxDuration => _maxDuration;
  String get currentDuration => _currentDuration;
}
