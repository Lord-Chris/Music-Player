import 'dart:math';

// import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/local_storage_service/i_local_storage_service.dart';
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
  ILocalStorageService _localStorage = locator<ILocalStorageService>();
  // TestingControls _controls = TestingControls();

  @override
  Future<IPlayerControls> initPlayer([bool load = false]) async {
    _playerImpl = PlayerControlImpl();
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> play([String? path]) async {
    try {
      if (path == null) {
        await _player.resume();
        return;
      }
      List<Track> list = getCurrentListOfSongs();
      list.forEach((element) {
        element.isPlaying = false;
      });
      int index = list.indexWhere((e) => e.filePath == path);
      list[index].isPlaying = true;
      await _localStorage.writeToBox(MUSICLIST, list);
      _player.play(path, isLocal: true);
      assert(
          list.where((e) => e.isPlaying).length == 1, "Playing is more than 1");

      // _playerState = AppPlayerState.Playing;
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
  }

  @override
  Track? getCurrentTrack() {
    try {
      List<Track> list = getCurrentListOfSongs();
      return list.firstWhere((e) => e.isPlaying);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Track> getCurrentListOfSongs() {
    String? _albumId = _localStorage.getFromBox(PLAYING_ALBUM);
    String? _artistId = _localStorage.getFromBox(PLAYING_ARTIST);
    final _tracks = _music.songs!;
    assert(_artistId == null || _albumId == null);

    if (_artistId != null) {
      final _artist = _music.artists?.firstWhere((e) => e.id == _artistId);
      if (_artist == null) return _tracks;
      _tracks.removeWhere((e) => _artist.trackIds?.contains(e) ?? true);
      return _tracks;
    }
    if (_albumId != null) {
      final _album = _music.albums?.firstWhere((e) => e.id == _albumId);
      if (_album == null) return _tracks;
      _tracks.removeWhere((e) => _album.trackIds?.contains(e) ?? true);
      return _tracks;
    }
    return _tracks;
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
