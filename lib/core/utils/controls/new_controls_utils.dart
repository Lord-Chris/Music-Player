import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/constants/pref_keys.dart';

import '../class_util.dart';
import '../music_util.dart';
import 'controls_util.dart';
import '../sharedPrefs.dart';

class AudioControls implements IAudioControls {
  static AudioControls _audioControls;
  SharedPrefs _prefs = locator<SharedPrefs>();
  Music _music = locator<IMusic>();
  AssetsAudioPlayer _player;

  List<Track> _songs;
  Playlist _playlist;

  @override
  int index;

  @override
  PlayerState state;

  @override
  List<String> recent;

  set songs(List<Track> value) {
    _songs = value;
    _playlist = Playlist(
      audios: _songs.map((e) => ClassUtil.toAudio(e)).toList(),
      startIndex: index,
    );
  }

  static Future<AudioControls> getInstance() async {
    if (_audioControls == null) {
      AudioControls placeHolder = AudioControls();
      await placeHolder.init();
      _audioControls = placeHolder;
    }
    return _audioControls;
  }

  @override
  Future<void> init() async {
    _player = AssetsAudioPlayer.withId('Music Player');
    index = _music.songs.indexWhere((song) => song.id == nowPlaying?.id) ?? 0;
    songs = _music.songs;
    _player.shuffle = _prefs.readBool(SHUFFLE, def: false) ? true : false;

    if (_player.isShuffling.value && _prefs.readBool(SHUFFLE, def: false)) {
      print("Player In sync //// true\n\n\n\n");
    }
    if (!_player.isShuffling.value && !_prefs.readBool(SHUFFLE, def: false)) {
      print("Player In sync //// false\n\n\n\n");
    }

    // recent = _prefs.recentlyPlayed.toList();
  }

  Future<void> playinginit() async {
    try {
      await _player.open(
        _playlist,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        playInBackground: PlayInBackground.enabled,
        respectSilentMode: true,
        showNotification: true,
        audioFocusStrategy:
            AudioFocusStrategy.request(resumeAfterInterruption: true),
        notificationSettings: NotificationSettings(
          nextEnabled: true,
          prevEnabled: true,
          stopEnabled: false,
          playPauseEnabled: true,
          customNextAction: (player) => next(),
          customPrevAction: (player) => previous(),
        ),
      );
      switch (_prefs.readString(REPEAT, def: 'off')) {
        case 'off':
          await _player.setLoopMode(LoopMode.none);
          break;
        case 'all':
          await _player.setLoopMode(LoopMode.playlist);
          break;
        case 'one':
          await _player.setLoopMode(LoopMode.single);
          break;
      }
    } catch (e) {
      print('\n\nPLAYINGINIT ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> playAndPause([bool isNewSong = false]) async {
    try {
      if (_songs.first.id != _player.playlist?.audios?.first?.metas?.id &&
          _songs.last.id != _player.playlist?.audios?.last?.metas?.id) {
        await playinginit();
        print('1');
        String id = _player?.current?.value?.audio?.audio?.metas?.id;
        if (id != nowPlaying?.id) {
          await _prefs.saveCurrentSong(songs.firstWhere(
            (element) => element.id == id,
            orElse: () => nowPlaying ?? _songs[1],
          ));
          throw Exception('the player is not playing the current song');
        }
        return;
      }
      if (isNewSong) {
        await _player.playlistPlayAtIndex(
            _songs.indexWhere((song) => song.id == nowPlaying.id));
        print('2');
        return;
      }
      if (state == PlayerState.stop) {
        await playinginit();
        print('3');
        return;
      }
      await _player.playOrPause();
      print('4');
      String id = _player?.current?.value?.audio?.audio?.metas?.id;
      if (id != nowPlaying?.id) {
        await _prefs.saveCurrentSong(songs.firstWhere(
          (element) => element.id == id,
          orElse: () => nowPlaying ?? _songs[1],
        ));
        throw Exception('the player is not playing the current song');
      }
    } on AssetsAudioPlayerError catch (e) {
      print('\n\n PLAYANDPAUSE ERROR 1: \n\n' + e.message);
      handleError(e);
    } catch (e) {
      print('\n\n PLAYANDPAUSE ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> next() async {
    try {
      await _player.next(keepLoopMode: false);
      setIndex(_player.current.value?.audio?.audio?.metas?.id);
    } catch (e) {
      print('\n\n NEXT ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> previous() async {
    try {
      await _player.previous(keepLoopMode: false);
      setIndex(_player.current.value.audio.audio.metas.id);
    } catch (e) {
      print('\n\n PREVIOUS ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> setIndex(String id) async {
    int songIndex = songs.indexWhere((element) => element.id == id);
    print(_songs[songIndex].title);
    await _prefs.saveCurrentSong(songs[songIndex]);
    index = songIndex;
  }

  @override
  Future<void> toggleRepeat() async {
    switch (_prefs.readString(REPEAT, def: 'off')) {
      case 'off':
        await _prefs.saveString(REPEAT, 'all');
        await _player.setLoopMode(LoopMode.playlist);
        break;
      case 'all':
        await _prefs.saveString(REPEAT, 'one');
        await _player.setLoopMode(LoopMode.single);
        break;
      case 'one':
        await _prefs.saveString(REPEAT, 'off');
        await _player.setLoopMode(LoopMode.none);
        break;
      default:
        await _prefs.saveString(REPEAT, 'all');
    }
    print('repeat is ${_prefs.readString(REPEAT, def: 'off')}');
  }

  @override
  Future<void> toggleShuffle() async {
    // _prefs.readBool(SHUFFLE, def: false)
    if (_player.isShuffling.value == true) {
      await _prefs.saveBool(SHUFFLE, false);
      _player.toggleShuffle();
    } else {
      await _prefs.saveBool(SHUFFLE, true);
      _player.toggleShuffle();
    }
    print('player shuffle is ${_player.isShuffling.value}');
    print('storage shuffle is ${_prefs.readBool(SHUFFLE, def: false)}');
  }

  @override
  Future<void> toggleFav(Track track) async {
    List<Track> list = _prefs.getfavorites();
    List<Track> fav = list.where((element) => element.id == track.id).toList();
    bool checkFav = fav == null || fav.isEmpty ? false : true;
    if (checkFav) {
      list.removeWhere((element) => element.id == track.id);
      await _prefs.setfavorites(list);
    } else {
      list.add(track);
      await _prefs.setfavorites(list);
    }
  }

  @override
  Stream<Track> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      yield nowPlaying;
    }
  }

  @override
  Future<void> setSliderPosition(double val) async {
    await _player.seek(Duration(milliseconds: val.toInt()));
  }

  void handleError(AssetsAudioPlayerError e) {
    _player.onErrorDo(
      ErrorHandler(
        error:
            AssetsAudioPlayerError(message: e.message, errorType: e.errorType),
        player: _player,
        currentPosition: null,
        playlist: _playlist,
        playlistIndex: index,
      ),
    );
  }

  List<Track> get songs => _songs;
  Track get nowPlaying => _prefs.getCurrentSong();
  Playing get playerCurrentSong => _player.current.value;
  Stream<PlayerState> get stateStream => _player.playerState;
  Stream<RealtimePlayingInfos> get currentSong => _player.realtimePlayingInfos;
  Stream<Duration> get sliderPosition => _player.currentPosition;
}
// @override
// void setRecent(String song) {
//   if (_prefs.recentlyPlayed != null) {
//     if (_prefs.recentlyPlayed.length < 5) {
//       recent = _prefs.recentlyPlayed?.toList();
//       if (!_prefs.recentlyPlayed.contains(song)) {
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       } else {
//         recent.removeWhere((element) => element == song);
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       }
//     } else {
//       if (!_prefs.recentlyPlayed.contains(song)) {
//         recent.removeLast();
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       } else {
//         recent.removeWhere((element) => element == song);
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       }
//     }
//   } else {
//     recent = [];
//     recent.insert(0, song);
//     _prefs.recentlyPlayed = recent.toSet();
//   }
// }
// if (!isPausebutton) {
//   await playinginit();
//   await _player.play();
// } else {
//   if (state == PlayerState.stop || state == null) {
//     await playinginit();
//     await _player.play();
//   } else {
//     await _player.playOrPause();
//   }
// }
