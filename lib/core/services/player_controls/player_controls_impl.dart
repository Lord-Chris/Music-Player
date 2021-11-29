import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/utils/general_utils.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';

import 'player_controls.dart';
import 'testing controls.dart';

class PlayerControlImpl extends IPlayerControls {
  static late PlayerControlImpl _playerImpl;
  AudioPlayer _player = AudioPlayer(playerId: '_player');
  SharedPrefs _prefs = locator<SharedPrefs>();
  IAudioFiles _music = locator<IAudioFiles>();
  TestingControls _controls = TestingControls();

  @override
  Future<IPlayerControls> initPlayer([bool load = false]) async {
    _playerImpl = PlayerControlImpl();
    if (load) await _controls.onStart({'path': getCurrentTrack()?.filePath});
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    // await _player.pause();
    await _controls.onPause();
  }

  @override
  Future<void> play([String? path]) async {
    try {
      if (path != null)
        await _controls.onStart({'path': path});
      else
        await _controls.onPlay();
      // List<Track> list;
      // if (path != null) {
      //   list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;
      //   await onStart(
      //       list.firstWhere((e) => e.id == getCurrentTrack().id).toMap());
      //   await _prefs.saveInt(
      //       NOWPLAYING, list.indexWhere((e) => e.filePath == path));
      // } else {
      //   await _player.resume();
      // }
      // _playerState = AppPlayerState.Playing;
    } on Exception catch (e) {
      print('PLAY ERROR: $e');
    }
  }

  @override
  Future<Track> playNext(int index, List<Track> list) async {
    await _controls.onSkipToNext();
    return getCurrentTrack()!;
    // late Track nextSong;
    // if (isShuffleOn) {
    //   nextSong = list.elementAt(Random().nextInt(list.length - 1));
    // } else {
    //   nextSong = index == list.length - 1
    //       ? list.elementAt(0)
    //       : list.elementAt(index + 1);
    // }
    // await play(nextSong.filePath!);
    // return nextSong;
  }

  @override
  Future<Track> playPrevious(int index, List<Track> list) async {
    await _controls.onSkipToPrevious();
    return getCurrentTrack()!;
    // late Track songBefore;
    // if (isShuffleOn) {
    //   songBefore = list.elementAt(Random().nextInt(list.length - 1));
    // } else {
    //   songBefore = index == 0
    //       ? list.elementAt(list.length - 1)
    //       : list.elementAt(index - 1);
    // }
    // await play(songBefore.filePath!);
    // return songBefore;
  }

  @override
  Future<void> toggleRepeat(Repeat val) async {
    try {
      await _controls
          .onSetRepeatMode(GeneralUtils.repeatToAudioServiceRepeat(val));

      // int curVal = Repeat.values.indexOf(val);
      // curVal == Repeat.values.length - 1
      //     ? await _prefs.saveInt(REPEAT, 0)
      //     : await _prefs.saveInt(REPEAT, curVal + 1);
    } catch (e) {
      print('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> toggleShuffle() async {
    // await _prefs.saveBool(SHUFFLE, !isShuffleOn);
    await _controls.onSetShuffleMode(!isShuffleOn
        ? AudioServiceShuffleMode.none
        : AudioServiceShuffleMode.all);
  }

  @override
  Track? getCurrentTrack() {
    try {
      List<Track> list;
      list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

      return list.elementAt(_prefs.readInt(NOWPLAYING, def: 0));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }

  @override
  Future<void> disposePlayer() async {
    // await _player.closeAudioSession();
  }

  @override
  bool get isPlaying => _player.state == PlayerState.PLAYING;

  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  bool get isShuffleOn => _prefs.readBool(SHUFFLE, def: false);

  @override
  Repeat get repeatState =>
      Repeat.values.elementAt(_prefs.readInt(REPEAT, def: 2));

  @override
  AppPlayerState get playerState =>
      GeneralUtils.formatPlayerState(_player.state);

  // Background services
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final mediaItem = MediaItem(
      id: params!['id'],
      album: params['album'],
      title: params['title'],
    );
    // Tell the UI and media notification what we're playing.
    await AudioServiceBackground.setMediaItem(mediaItem);
    print('DID RHIS');
    // Listen to state changes on the player...
    _player.onPlayerStateChanged.listen((playerState) {
      AppPlayerState state = GeneralUtils.formatPlayerState(playerState);

      // ... and forward them to all audio_service clients.
      AudioServiceBackground.setState(
        playing: state == AppPlayerState.Playing,
        // Every state from the audio player gets mapped onto an audio_service state.
        processingState: {
          AppPlayerState.Idle: AudioProcessingState.none,
          AppPlayerState.Playing: AudioProcessingState.ready,
          // AppPlayerState.Paused: AudioProcessingState.,
          AppPlayerState.Finished: AudioProcessingState.completed,
        }[state],
        // Tell clients what buttons/controls should be enabled in the
        // current state.
        controls: [
          state == AppPlayerState.Playing
              ? MediaControl.pause
              : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
        ],
      );
    });
    // Play when ready.
    await _player.play(params['path'], isLocal: true);
    // Start loading something (will play when ready).
    // await _player.setUrl(mediaItem.id);
  }

  @override
  Future<void> onPause() => pause();

  @override
  Future<void> onPlay() => play();

  @override
  Future<void> onSkipToNext() {
    List<Track> list;
    list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

    return playNext(
        list.indexWhere((e) => e.id == getCurrentTrack()!.id), list);
  }

  @override
  Future<void> onSkipToPrevious() {
    List<Track> list;
    list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

    return playPrevious(
        list.indexWhere((e) => e.id == getCurrentTrack()!.id), list);
  }
}
