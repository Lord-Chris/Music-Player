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

class TestingControls extends BackgroundAudioTask {
  AudioPlayer _player = AudioPlayer(playerId: '_player');
  late SharedPrefs _prefs;
  late IAudioFiles _music;
  Track? _currentSong;
  Track? nextSong;

  // @override
  // Future<void> onAddQueueItem(MediaItem mediaItem) {
  //   // TODO: implement onAddQueueItem
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> onAddQueueItemAt(MediaItem mediaItem, int index) {
  //   // TODO: implement onAddQueueItemAt
  //   throw UnimplementedError();
  // }

  @override
  Future<void> onPause() async {
    await _player.pause();
  }

  @override
  Future<void> onPlay() async {
    try {
      String? song = (nextSong ?? _currentSong)?.filePath;
      if (song != null) _player.play(song, isLocal: true);
      nextSong = null;
    } catch (e) {
      print('PLAY ERROR: $e');
    }
    // await _player.play(params['path'], isLocal: true);
  }

  // @override
  // Future<void> onPlayMediaItem(MediaItem mediaItem) {
  //   // TODO: implement onPlayMediaItem
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> onPrepare() {
  //   // TODO: implement onPrepare
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> onPrepareFromMediaId(String mediaId) {
  //   // TODO: implement onPrepareFromMediaId
  //   throw UnimplementedError();
  // }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode mode) async {
    try {
      int curVal =
          Repeat.values.indexOf(GeneralUtils.audioServiceRepeatToRepeat(mode));
      curVal == Repeat.values.length - 1
          ? await _prefs.saveInt(REPEAT, 0)
          : await _prefs.saveInt(REPEAT, curVal + 1);
      await AudioService.setRepeatMode(mode);
    } catch (e) {
      print('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode mode) async {
    try {
      bool curVal = mode == AudioServiceShuffleMode.none ? false : true;
      await _prefs.saveBool(SHUFFLE, !curVal);
      await AudioService.setShuffleMode(mode);
    } catch (e) {
      print('TOGGLE SHUFFLE: $e');
    }
  }

  @override
  Future<void> onSkipToNext() async {
    List<Track> list =
        _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;
    int index = _prefs.readInt(NOWPLAYING, def: 0);
    if ('isShuffleOn' == '') {
      nextSong = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      nextSong = index == list.length - 1
          ? list.elementAt(0)
          : list.elementAt(index + 1);
    }
    _prefs.saveInt(NOWPLAYING, list.indexWhere((e) => e.id == nextSong!.id));
    await onPlay();
    return;
  }

  @override
  Future<void> onSkipToPrevious() async {
    List<Track> list =
        _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;
    int index = _prefs.readInt(NOWPLAYING, def: 0);

    if ('isShuffleOn' == '') {
      nextSong = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      nextSong = index == 0
          ? list.elementAt(list.length - 1)
          : list.elementAt(index - 1);
    }
    _prefs.saveInt(NOWPLAYING, list.indexWhere((e) => e.id == nextSong!.id));
    await onPlay();
    return;
  }

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    try {
      String? filePath = params?['path'];
      _music = locator<IAudioFiles>();
      _prefs = locator<SharedPrefs>();
      List<Track> list;

      if (filePath != null) {
        list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

        _player.onPlayerStateChanged.listen((playerState) {
          AppPlayerState state = GeneralUtils.formatPlayerState(playerState);

          // ... and forward them to all audio_service clients.
          AudioServiceBackground.setState(
            playing: state == AppPlayerState.Playing,
            // Every state from the audio player gets mapped onto an audio_service state.
            processingState: AudioProcessingState.buffering,

            // {
            //   AppPlayerState.Idle: AudioProcessingState.none,
            //   AppPlayerState.Playing: AudioProcessingState.ready,
            //   AppPlayerState.Paused: AudioProcessingState.buffering,
            //   AppPlayerState.Finished: AudioProcessingState.completed,
            // }[state],
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

        AudioServiceBackground.setQueue(GeneralUtils.trackToMediaItem(list));
        Track _track;
        _currentSong = _track = list.firstWhere((e) => e.filePath == filePath);

        final mediaItem = MediaItem(
          id: _track.id!,
          album: _track.album!,
          title: _track.title!,
        );

        await AudioServiceBackground.setMediaItem(mediaItem);
        onPlay();

        await _prefs.saveInt(
            NOWPLAYING, list.indexWhere((e) => e.filePath == params?['path']));
      } else {
        await _player.resume();
      }
    } catch (e) {
      print('START ERROR: $e');
    }
  }

  @override
  Future<void> onStop() async {
    _player.stop();
    super.onStop();
  }

  // @override
  // Future<void> onUpdateMediaItem(MediaItem mediaItem) {
  //   // TODO: implement onUpdateMediaItem
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> onUpdateQueue(List<MediaItem> queue) {
  //   // TODO: implement onUpdateQueue
  //   throw UnimplementedError();
  // }

  // Track ? getCurrentTrack() {
  //   try {
  //     List<Track> list;
  //     list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

  //     return list.elementAt(_prefs.readInt(NOWPLAYING, def: 0));
  //   } catch (e) {
  //     return _music.songs.elementAt(_prefs.readInt(NOWPLAYING));
  //   }
  // }
}
