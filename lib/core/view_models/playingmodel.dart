import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class PlayingProvider extends BaseModel {
  AudioControls _controls = locator<AudioControls>();
  double _songDuration = 2;
  String _maxDuration = '--:--';
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  set songs(List<Track> list) => _controls.songs = list;

  void onModelReady(int index, bool play) {
    _controls.index = index;
    play ? _controls.play(): null;
    // setState();
    songTotalTime();
  }

  // void setState() async {
  //   _controls.onCompletion.listen((event) {}).onData((data) async {
  //     _controls.state = AudioPlayerState.COMPLETED;
  //     if (_sharedPrefs.repeat == 'one') {
  //       await _controls.play();
  //       notifyListeners();
  //     } else if (_sharedPrefs.repeat == 'off' &&
  //         _controls.index == _controls.songs.length - 1) {
  //       return null;
  //     } else {
  //       next();
  //     }
  //   });
  // }

  void setFav() {
    print(nowPlaying.favorite);
    nowPlaying.favorite = !nowPlaying.isFavorite;
    notifyListeners();
    print(nowPlaying.isFavorite);
  }

  void onPlayButtonTap() async {
    await _controls.playAndPause();
    notifyListeners();
  }

  Future<void> next() async {
    await _controls.next();
    notifyListeners();
  }

  Future<void> previous() async {
    await _controls.previous();
    notifyListeners();
  }

  String getDuration({Duration duration}) {
    String time = duration.toString();
    int len = time.length;
    return convertToString(len, time);
  }

  String convertToString(int len, String time) {
    if (len == 14 && time[0] != '0')
      return time.substring(0, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] == '0')
      return time.substring(3, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] != '0')
      return time.substring(2, len - 7);
    else if (time == null || len == null)
      return null;
    else
      return '--:--';
  }

  void songTotalTime() {
    _controls.audioPlayer.onDurationChanged.listen((duration) {
      String time = duration.toString();
      int len = time.length;
      _maxDuration = convertToString(len, time);
      _songDuration = duration.inMilliseconds.toDouble();
    });
  }

  Future<void> setSliderPosition(double val) async {
    await _controls.audioPlayer.seek(Duration(milliseconds: val.toInt()));
    print(state);
    notifyListeners();
  }

  void toggleShuffle() {
    _sharedPrefs.shuffle = !_sharedPrefs.shuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    // print('repeat is ${_sharedPrefs.repeat}');
    if (_sharedPrefs.repeat == 'off') {
      _sharedPrefs.repeat = 'all';
      notifyListeners();
    } else if (_sharedPrefs.repeat == 'all') {
      _sharedPrefs.repeat = 'one';
      notifyListeners();
    } else {
      _sharedPrefs.repeat = 'off';
      notifyListeners();
    }
  }

  AudioPlayerState get state => _controls.state;
  Stream<Duration> get sliderPosition =>
      _controls.audioPlayer.onAudioPositionChanged;
  double get songDuration => _songDuration;
  String get maxDuration => _maxDuration;
  Track get nowPlaying => _sharedPrefs.currentSong;
  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
}
