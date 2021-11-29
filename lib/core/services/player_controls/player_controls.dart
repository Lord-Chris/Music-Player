import 'package:audio_service/audio_service.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';

abstract class IPlayerControls extends BackgroundAudioTask{
  bool get isPlaying;
  bool get isShuffleOn;
  Repeat get repeatState;
  Stream<Duration> get currentDuration;
  AppPlayerState get playerState;

  Future<IPlayerControls?> initPlayer([bool load = false]);
  Future<void> play([String? path]);
  Future<void> pause();
  Future<Track> playNext(int index, List<Track> list);
  Future<Track> playPrevious(int index, List<Track> list);
  Future<void> toggleShuffle();
  Future<void> toggleRepeat(Repeat val);
  Track? getCurrentTrack();
  Future<void> updateSongPosition(Duration val);
  Future<void> disposePlayer();
}
