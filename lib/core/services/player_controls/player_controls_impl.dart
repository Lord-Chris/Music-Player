import 'dart:math';

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

class PlayerControlImpl implements IPlayerControls {
  static late PlayerControlImpl _playerImpl;
  AudioPlayer _player = AudioPlayer(playerId: '_player');
  SharedPrefs _prefs = locator<SharedPrefs>();
  IAudioFiles _music = locator<IAudioFiles>();
  late AppPlayerState _playerState;

  @override
  Future<IPlayerControls> initPlayer() async {
    _playerImpl = PlayerControlImpl();
    _playerImpl._playerState = AppPlayerState.Idle;
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _playerState = AppPlayerState.Paused;
  }

  @override
  Future<void> play([String? path]) async {
    try {
      if (path != null) {
        await _player.play(path, isLocal: true);
        await _prefs.saveInt(
            NOWPLAYING, _music.songs.indexWhere((e) => e.filePath == path));
      } else {
        await _player.resume();
      }
      _playerState = AppPlayerState.Playing;
    } on Exception catch (e) {
      print('PLAY ERROR: $e');
    }
  }

  @override
  Future<Track> playNext(int index, List<Track> list) async {
    late Track nextSong;
    if (isShuffleOn) {
      nextSong = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      nextSong = index == list.length - 1
          ? list.elementAt(0)
          : list.elementAt(index + 1);
    }
    await play(nextSong.filePath!);
    return nextSong;
  }

  @override
  Future<Track> playPrevious(int index, List<Track> list) async {
    late Track songBefore;
    if (isShuffleOn) {
      songBefore = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      songBefore = index == 0
          ? list.elementAt(list.length - 1)
          : list.elementAt(index - 1);
    }
    await play(songBefore.filePath!);
    return songBefore;
  }

  @override
  Future<void> toggleRepeat(Repeat val) async {
    try {
      int curVal = Repeat.values.indexOf(val);
      curVal == Repeat.values.length - 1
          ? await _prefs.saveInt(REPEAT, 0)
          : await _prefs.saveInt(REPEAT, curVal + 1);
    } catch (e) {
      print('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> toggleShuffle() async {
    await _prefs.saveBool(SHUFFLE, !isShuffleOn);
  }

  @override
  Track getCurrentTrack() {
    return _music.songs.elementAt(_prefs.readInt(NOWPLAYING, def: 0));
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
}
