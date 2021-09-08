import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';

abstract class IPlayerControls {
  bool get isPlaying;
  bool get isShuffleOn;
  Repeat get repeatState;
  Stream<Duration> get currentDuration;
  AppPlayerState get playerState;

  Future<IPlayerControls?> initPlayer();
  Future<void> play([String? path]);
  Future<void> pause();
  Future<Track> playNext(int index, List<Track> list);
  Future<Track> playPrevious(int index, List<Track> list);
  Future<void> toggleShuffle();
  Future<void> toggleRepeat(Repeat val);
  Track getCurrentTrack();
  Future<void> updateSongPosition(Duration val);
  Future<void> disposePlayer();
}
