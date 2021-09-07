import 'package:music_player/core/models/track.dart';

abstract class IPlayerControls {
  bool get isPlaying;
  Stream<Duration> get currentDuration;

  Future<IPlayerControls?> initPlayer();
  Future<void> play([String? path]);
  Future<void> pause();
  Future<Track> playNext(int index, List<Track> list);
  Future<Track> playPrevious(int index, List<Track> list);
  void toggleShuffle();
  void toggleRepeat();
  Future<void> updateSongPosition(Duration val);
  Future<void> disposePlayer();
}
