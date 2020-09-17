import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/viewmodels/base_model.dart';

class PlayingProvider extends BaseModel {
  List<SongInfo> _songs = Music().songs;
  double _sliderPosition = 0;
  double _songDuration = 1;
  String _maxDuration = '--:--';
  String _currentDuration = '--:--';
  AudioPlayer _audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
  AudioPlayerState _state;
  SongInfo _nowPlaying;
  int _index;

  getSong(int index) {
    _nowPlaying = _songs[index];
    _index = index;
    notifyListeners();
  }

  void onModelReady(int index) {
    getSong(index);
    play();
    getDuration();
    getSliderPosition();
  }

  void onModelFinished() {}

  void play() {
    _audioPlayer.play(_nowPlaying.filePath);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      print(state);
      _state = state;
      notifyListeners();
    });
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  void next() {
    _index += 1;
    notifyListeners();
    getSong(_index);
    play();
  }

  void previous() {
    _index -= 1;
    notifyListeners();
    getSong(_index);
    play();
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
//      print(duration);
    });
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

  Future<void> setSliderPosition(double val) async {
    await _audioPlayer.seek(Duration(milliseconds: val.toInt()));
    notifyListeners();
  }

  test() {}

  double get sliderPosition => _sliderPosition;
  double get songDuration => _songDuration;
  String get maxDuration => _maxDuration;
  String get currentDuration => _currentDuration;
  SongInfo get nowPlaying => _nowPlaying;
  AudioPlayerState get state => _state;
}
