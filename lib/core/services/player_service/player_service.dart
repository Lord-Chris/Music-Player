import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/_constants.dart';

class PlayerService extends IPlayerService {
  // static late PlayerService _playerImpl;
  final _player = AudioPlayer(playerId: '_player');
  final _prefs = locator<SharedPrefs>();
  final _music = locator<IAudioFileService>();
  final _localStorage = locator<ILocalStorageService>();
  final _appAudioService = locator<IAppAudioService>();
  late StreamSubscription<PlayerState> _playerStateSub;

  AudioHandler? _audioHandler;

  @override
  void initialize([bool load = false]) {
    _playerStateSub = _player.onPlayerStateChanged.listen((event) {
      print(event);
      _appAudioService.playerStateController
          .add(GeneralUtils.formatPlayerState(event));
    });
  }

  @override
  Future<void> pause() async {
    _appAudioService.playerStateController.add(AppPlayerState.Paused);
    await _player.pause();
  }

  @override
  Future<void> play([Track? track]) async {
    try {
      if (track == null) {
        _appAudioService.playerStateController.add(AppPlayerState.Playing);
        await _player.resume();
        return;
      }

      // set all tracks to not playing
      List<Track> list = _music.songs!;
      for (var element in list) {
        element.isPlaying = false;
      }

      // set new song to playing
      int index = list.indexWhere((e) => e.id == track.id);
      list[index].isPlaying = true;
      await _localStorage.writeToBox(MUSICLIST, list);
      _appAudioService.currentTrackController.add(list[index]);

      // pass song to audio handler
      _audioHandler ??= locator<AudioHandler>();
      _audioHandler!.updateMediaItem(
        GeneralUtils.trackToMediaItem(_appAudioService.currentTrack!),
      );

      // play song
      _appAudioService.playerStateController.add(AppPlayerState.Playing);
      await _player.play(track.filePath!, isLocal: true);
      assert(
          list.where((e) => e.isPlaying).length == 1, "Playing is more than 1");
    } on Exception catch (e) {
      print('PLAY ERROR: $e');
      return;
    }
  }

  @override
  Future<Track> playNext() async {
    List<Track> list = _appAudioService.currentTrackList;
    int index = list.indexWhere((e) => e == _appAudioService.currentTrack);

    late Track nextSong;
    if (isShuffleOn) {
      nextSong = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      nextSong = index == list.length - 1
          ? list.elementAt(0)
          : list.elementAt(index + 1);
    }
    await play(nextSong);
    return nextSong;
  }

  @override
  Future<Track> playPrevious() async {
    List<Track> list = _appAudioService.currentTrackList;
    int index =
        list.indexWhere((e) => e.id == _appAudioService.currentTrack!.id);
    late Track songBefore;
    if (isShuffleOn) {
      songBefore = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      songBefore = index == 0
          ? list.elementAt(list.length - 1)
          : list.elementAt(index - 1);
    }
    await play(songBefore);
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

  List<Track> _getCurrentListOfSongs() {
    final _albums = _music.albums;
    final _artists = _music.artists;
    List<Track> _tracks = _music.songs!;

    final _artistIndex = _music.artists?.indexWhere((e) => e.isPlaying);
    final _albumIndex = _music.albums?.indexWhere((e) => e.isPlaying);

    if (_artistIndex! > -1) {
      final _artist = _artists![_artistIndex];
      _tracks = _tracks
          .where((element) => _artist.trackIds!.contains(element.id))
          .toList();
    }
    if (_albumIndex! > -1) {
      final _album = _albums![_albumIndex];
      _tracks = _tracks
          .where((element) => _album.trackIds!.contains(element.id))
          .toList();
    }
    // if (isShuffleOn) _tracks.shuffle();
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
      final _artistIndex = _artists?.indexWhere((e) => e.id == listId);
      final _albumIndex = _albums?.indexWhere((e) => e.id == listId);
      if (_albumIndex! > -1) {
        _albums![_albumIndex].isPlaying = true;
        _appAudioService.currentAlbumController.add(_albums[_albumIndex]);
      } else if (_artistIndex! > -1) {
        _artists![_artistIndex].isPlaying = true;
        _appAudioService.currentArtistController.add(_artists[_artistIndex]);
      }
    }

    // upload the new values to local database
    await _localStorage.writeToBox(ALBUMLIST, _albums);
    await _localStorage.writeToBox(ARTISTLIST, _artists);
    _audioHandler ??= locator<AudioHandler>();
    final _list = _getCurrentListOfSongs();
    _appAudioService.currentTrackListController.add(_list);
    await _audioHandler!
        .updateQueue(GeneralUtils.trackListToMediaItemList(_list));
  }

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }

  @override
  Future<void> dispose() async {
    _playerStateSub.cancel();
  }

  @override
  bool get isPlaying => _appAudioService.playerState == AppPlayerState.Playing;

  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  bool get isShuffleOn => _prefs.readBool(SHUFFLE, def: false);

  @override
  Repeat get repeatState => _localStorage.getFromBox(REPEAT, def: Repeat.Off);
}
