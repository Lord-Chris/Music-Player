import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

class PlayingProvider extends BaseModel {
  List<Track> _songs = locator<Music>().songs;
  AudioPlayer _audioPlayer =
      AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
  AudioPlayerState _state;
  double _songDuration = 1;
  String _maxDuration = '--:--';
  Track _nowPlaying;
  int _index;
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();

  set songs(List<Track> list) {
    _songs = list;
    notifyListeners();
  }

  set index(int index) {
    _nowPlaying = _songs[index];
    _index = index;
    notifyListeners();
  }

  void onModelReady(int _index) {
    index = _index;
    play();
    songTotalTime();
  }

  void play() {
    try {
      _audioPlayer.play(_nowPlaying.filePath);
      _audioPlayer.onPlayerStateChanged.listen((state) {
        // print(state);
        _state = state;
        if (state == AudioPlayerState.COMPLETED) next();
        notifyListeners();
      });
    } catch (e) {
      print('play error: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  void next() {
    try {
      _sharedPrefs.shuffle
          ? _index = Random().nextInt(_songs.length)
          : _index += 1;
      notifyListeners();
      index = _index;
      play();
    } catch (e) {
      print('next error: $e');
    }
  }

  void previous() {
    _sharedPrefs.shuffle
        ? _index = Random().nextInt(_songs.length)
        : _index -= 1;
    notifyListeners();
    index = _index;
    play();
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
    _audioPlayer.onDurationChanged.listen((duration) {
      String time = duration.toString();
      int len = time.length;
      _maxDuration = convertToString(len, time);
      _songDuration = duration.inMilliseconds.toDouble();
    });
  }

  Future<void> setSliderPosition(double val) async {
    await _audioPlayer.seek(Duration(milliseconds: val.toInt()));
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

  AudioPlayerState get state => _state;
  Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
  double get songDuration => _songDuration;
  String get maxDuration => _maxDuration;
  Track get nowPlaying => _nowPlaying;
  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
}
