// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/_constants.dart';

class PlayerService extends IPlayerService {
  final _player = AudioPlayer(playerId: '_player');
  final _prefs = locator<SharedPrefs>();
  final _music = locator<IAudioFileService>();
  final _localStorage = locator<ILocalStorageService>();
  final _appAudioService = locator<IAppAudioService>();
  final _log = Logger();
  late StreamSubscription<PlayerState> _playerStateSub;

  AudioHandler? _audioHandler;
  final double _volume = 1;

  @override
  void initialize([bool load = false]) {
    _playerStateSub = _player.onPlayerStateChanged.listen((event) {
      _appAudioService.playerStateController
          .add(GeneralUtils.formatPlayerState(event));
    });
    _player.setVolume(_volume);
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

      // play song
      _appAudioService.playerStateController.add(AppPlayerState.Playing);
      await _player.play(track.filePath!, isLocal: true);

      // set new song to playing
      int index = list.indexWhere((e) => e.id == track.id);
      list[index].isPlaying = true;
      _appAudioService.currentTrackController.add(list[index]);

      // pass song to audio handler
      _audioHandler ??= locator<AudioHandler>();
      _audioHandler!.updateMediaItem(
        GeneralUtils.trackToMediaItem(list[index]),
      );

      _localStorage.writeToBox(MUSICLIST, list);
      assert(
        list.where((e) => e.isPlaying).length == 1,
        "Tracks set to playing are more than one",
      );
    } on Exception catch (e) {
      _log.e('PLAY ERROR: $e');
      return;
    }
  }

  @override
  Future<Track> playNext() async {
    List<Track> list = _appAudioService.currentTrackList;
    int index =
        list.indexWhere((e) => e.id == _appAudioService.currentTrack!.id);
    late Track nextSong;
    nextSong = index == list.length - 1
        ? list.elementAt(0)
        : list.elementAt(index + 1);
    await play(nextSong);
    return nextSong;
  }

  @override
  Future<Track> playPrevious() async {
    List<Track> list = _appAudioService.currentTrackList;
    int index =
        list.indexWhere((e) => e.id == _appAudioService.currentTrack!.id);
    late Track songBefore;
    songBefore = index == 0
        ? list.elementAt(list.length - 1)
        : list.elementAt(index - 1);
    await play(songBefore);
    return songBefore;
  }

  @override
  void setTrackAsNext(Track track) {
    assert(_appAudioService.currentTrack != null,
        "Current track must not be null");
    final _list = _appAudioService.currentTrackList;
    _list.removeWhere((e) => e == track);
    final _index = _list.indexOf(_appAudioService.currentTrack!);
    _list.insert(_index + 1, track);
    _localStorage.writeToBox(CURRENTTRACKLIST, _list);
    _appAudioService.currentTrackListController.add(_list);
  }

  @override
  Future<void> toggleRepeat() async {
    try {
      final _currentIndex = Repeat.values.indexOf(repeatState);
      _currentIndex == Repeat.values.length - 1
          ? _localStorage.writeToBox(REPEAT, Repeat.values[0])
          : _localStorage.writeToBox(REPEAT, Repeat.values[_currentIndex + 1]);
    } catch (e) {
      _log.e('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> toggleShuffle() async {
    final _list = _appAudioService.currentTrackList;
    if (!isShuffleOn) {
      _list.shuffle();
    } else {
      _list.sort((a, b) => (a.displayName?.toLowerCase() ?? "")
          .compareTo(b.displayName?.toLowerCase() ?? ""));
    }
    _appAudioService.currentTrackListController.add(_list);
    _localStorage.writeToBox(CURRENTTRACKLIST, _list);
    await _prefs.saveBool(SHUFFLE, !isShuffleOn);
  }

  @override
  Future<void> changeCurrentListOfSongs([String? listId]) async {
    // create instances
    final _albums = _music.albums;
    final _artists = _music.artists;
    final _favs = _music.favourites;
    List<Track> _tracks = _music.songs!;

    // set all albums and artist isPlaying value to false
    _albums?.forEach((e) => e.isPlaying = false);
    _artists?.forEach((e) => e.isPlaying = false);
    _favs.forEach((e) => e.isPlaying = false);

    // check which album or artist to set
    if (listId != null) {
      assert(listId.isNotEmpty, "List Id cannot be empty");
      final _artistIndex = _artists?.indexWhere((e) => e.id == listId);
      final _albumIndex = _albums?.indexWhere((e) => e.id == listId);
      if (_albumIndex! > -1) {
        final _album = _albums![_albumIndex];
        _album.isPlaying = true;
        _appAudioService.currentAlbumController.add(_album);
        _tracks =
            _tracks.where((e) => _album.trackIds!.contains(e.id)).toList();
      } else if (_artistIndex! > -1) {
        final _artist = _artists![_artistIndex];
        _artist.isPlaying = true;
        _appAudioService.currentArtistController.add(_artist);
        _tracks =
            _tracks.where((e) => _artist.trackIds!.contains(e.id)).toList();
      } else if (listId == FAVOURITES) {
        _tracks = _tracks.where((e) => e.isFavorite).toList();
      }
    }
    _appAudioService.currentTrackListController.add(_tracks);
    _audioHandler ??= locator<AudioHandler>();
    _audioHandler!.updateQueue(GeneralUtils.trackListToMediaItemList(_tracks));

    // upload the new values to local database
    _localStorage.writeToBox(ALBUMLIST, _albums);
    _localStorage.writeToBox(ARTISTLIST, _artists);
    _localStorage.writeToBox(CURRENTTRACKLIST, _tracks);
  }

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }

  @override
  Future<void> setVolume(double value) async {
    await _player.setVolume(value);
  }

  @override
  Future<void> dispose() async {
    _playerStateSub.cancel();
  }

  @override
  bool get isPlaying => _appAudioService.playerState == AppPlayerState.Playing;

  @override
  double get volume => _volume;
  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  bool get isShuffleOn => _prefs.readBool(SHUFFLE, def: false);

  @override
  Repeat get repeatState => _localStorage.getFromBox(REPEAT, def: Repeat.Off);
}
