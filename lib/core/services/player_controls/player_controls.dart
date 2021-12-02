// import 'package:audio_service/audio_service.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';

abstract class IPlayerControls {
  bool get isPlaying;
  bool get isShuffleOn;
  Repeat get repeatState;
  Stream<Duration> get currentDuration;
  Stream<AppPlayerState> get playerStateStream;
  AppPlayerState get playerState;

  Future<IPlayerControls?> initPlayer([bool load = false]);
  Future<void> play([String? path]);
  Future<void> pause();
  Future<Track> playNext(int index);
  Future<Track> playPrevious(int index);
  Future<void> toggleShuffle();
  Future<void> toggleRepeat();
  Track? getCurrentTrack();
  List<Track> getCurrentListOfSongs();
  Future<void> changeCurrentListOfSongs([String? listId]);
  Future<void> updateSongPosition(Duration val);
  Future<void> updatePlayerState(AppPlayerState state);
  Future<void> disposePlayer();
}
