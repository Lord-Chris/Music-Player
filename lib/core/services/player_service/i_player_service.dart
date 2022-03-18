// import 'package:audio_service/audio_service.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';

abstract class IPlayerService {
  bool get isPlaying;
  bool get isShuffleOn;
  Repeat get repeatState;
  Stream<Duration> get currentDuration;
  // Stream<AppPlayerState> get playerStateStream;
  // AppPlayerState get playerState;

  void initialize([bool load = false]);
  Future<void> play([Track? track]);
  Future<void> pause();
  Future<Track> playNext();
  Future<Track> playPrevious();
  Future<void> toggleShuffle();
  Future<void> toggleRepeat();
  // Track? getCurrentTrack();
  // List<Track> getCurrentListOfSongs();
  Future<void> changeCurrentListOfSongs([String? listId]);
  Future<void> updateSongPosition(Duration val);
  // Future<void> updatePlayerState(AppPlayerState state);
  Future<void> dispose();
}
