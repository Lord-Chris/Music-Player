import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/viewmodels/base_model.dart';

class PlayingProvider extends BaseModel {
  List<SongInfo> _songs = Music().songs;
  double _songDuration = 1;
  String _maxDuration = '--:--';
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
      _index += 1;
      notifyListeners();
      getSong(_index);
      play();
    } catch (e) {
      print('next error: $e');
    }
  }

  void previous() {
    _index -= 1;
    notifyListeners();
    getSong(_index);
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

  Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
  double get songDuration => _songDuration;
  String get maxDuration => _maxDuration;
  SongInfo get nowPlaying => _nowPlaying;
  AudioPlayerState get state => _state;
}
