import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:musicool/core/utils/general_utils.dart';
import 'package:musicool/core/utils/sharedPrefs.dart';
import 'package:musicool/ui/constants/pref_keys.dart';

import 'player_controls.dart';

class PlayerControlImpl extends IPlayerControls {
  static late PlayerControlImpl _playerImpl;
  AudioPlayer _player = AudioPlayer(playerId: '_player');
  SharedPrefs _prefs = locator<SharedPrefs>();
  IAudioFiles _music = locator<IAudioFiles>();
  ILocalStorageService _localStorage = locator<ILocalStorageService>();
  AudioHandler? _audioHandler;

  @override
  Future<IPlayerControls> initPlayer([bool load = false]) async {
    _playerImpl = PlayerControlImpl();
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    updatePlayerState(AppPlayerState.Paused);
    await _player.pause();
  }

  @override
  Future<void> play([String? path]) async {
    try {
      if (path == null) {
        updatePlayerState(AppPlayerState.Playing);
        await _player.resume();
        return;
      }

      // set all tracks to not playing
      List<Track> list = _music.songs!;
      list.forEach((element) => element.isPlaying = false);

      // set new song to playing
      int index = list.indexWhere((e) => e.filePath == path);
      list[index].isPlaying = true;
      await _localStorage.writeToBox(MUSICLIST, list);

      // pass song to audio handler
      if (_audioHandler == null) _audioHandler = locator<AudioHandler>();
      _audioHandler!
          .updateMediaItem(GeneralUtils.trackToMediaItem(getCurrentTrack()!));

      // play song 
      updatePlayerState(AppPlayerState.Playing);
      _player.play(path, isLocal: true);
      assert(
          list.where((e) => e.isPlaying).length == 1, "Playing is more than 1");
    } on Exception catch (e) {
      print('PLAY ERROR: $e');
    }
  }

  @override
  Future<Track> playNext() async {
    List<Track> list = getCurrentListOfSongs();
    int index = list.indexWhere((e) => e.id == getCurrentTrack()!.id);

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
  Future<Track> playPrevious() async {
    List<Track> list = getCurrentListOfSongs();
    int index = list.indexWhere((e) => e.id == getCurrentTrack()!.id);
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
  Future<void> toggleRepeat() async {
    try {
      final _currentIndex = Repeat.values.indexOf(repeatState);
      _currentIndex == Repeat.values.length - 1
          ? _localStorage.writeToBox(REPEAT, Repeat.values[0])
          : _localStorage.writeToBox(REPEAT, Repeat.values[_currentIndex + 1]);
    } catch (e) {
      print('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> toggleShuffle() async {
    await _prefs.saveBool(SHUFFLE, !isShuffleOn);
  }

  @override
  Track? getCurrentTrack() {
    try {
      List<Track> list = getCurrentListOfSongs();
      final track = list.firstWhere((e) => e.isPlaying);
      if (_audioHandler == null) _audioHandler = locator<AudioHandler>();
      _audioHandler!.updateMediaItem(GeneralUtils.trackToMediaItem(track));
      return track;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Track> getCurrentListOfSongs() {
    final _albums = _music.albums;
    final _artists = _music.artists;
    final _tracks = _music.songs!;

    final _artistIndex = _music.artists?.indexWhere((e) => e.isPlaying);
    final _albumIndex = _music.albums?.indexWhere((e) => e.isPlaying);

    if (_artistIndex! > -1) {
      final _artist = _artists![_artistIndex];
      return _tracks
          .where((element) => _artist.trackIds!.contains(element.id))
          .toList();
    }
    if (_albumIndex! > -1) {
      final _album = _albums![_albumIndex];
      return _tracks
          .where((element) => _album.trackIds!.contains(element.id))
          .toList();
    }
    return _tracks;
  }

  @override
  Future<void> changeCurrentListOfSongs([String? listId]) async {
    // create instances
    final _albums = _music.albums;
    final _artists = _music.artists;

    // set all albums and artist isPlaying value to false
    _albums?.forEach((e) => e.isPlaying = false);
    _artists?.forEach((e) => e.isPlaying = false);

    // check which album or artist to set
    if (listId != null) {
      assert(listId.isNotEmpty, "List Id cannot be empty");
      final _artistIndex = _artists?.indexWhere((e) => e.name == listId);
      final _albumIndex = _albums?.indexWhere((e) => e.id == listId);
      if (_albumIndex! > -1) {
        _albums![_albumIndex].isPlaying = true;
      } else if (_artistIndex! > -1) {
        _artists![_artistIndex].isPlaying = true;
      }
    }

    // upload the new values to local database
    await _localStorage.writeToBox(ALBUMLIST, _albums);
    await _localStorage.writeToBox(ARTISTLIST, _artists);
    if (_audioHandler == null) _audioHandler = locator<AudioHandler>();
    await _audioHandler!.updateQueue(
        GeneralUtils.trackListToMediaItemKist(getCurrentListOfSongs()));
  }

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }

  @override
  Future<void> updatePlayerState(AppPlayerState state) async {
    await _localStorage.writeToBox(PLAYER_STATE, state);
    print("CURRENT PLAYER STATE: $state");
  }

  @override
  Future<void> disposePlayer() async {
    // await _player.closeAudioSession();
  }

  @override
  bool get isPlaying => playerState == AppPlayerState.Playing;

  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  Stream<AppPlayerState> get playerStateStream => _player.onPlayerStateChanged
      .map((e) => GeneralUtils.formatPlayerState(e));

  @override
  bool get isShuffleOn => _prefs.readBool(SHUFFLE, def: false);

  @override
  Repeat get repeatState => _localStorage.getFromBox(REPEAT, def: Repeat.Off);

  @override
  AppPlayerState get playerState =>
      _localStorage.getFromBox(PLAYER_STATE, def: AppPlayerState.Idle);
}
