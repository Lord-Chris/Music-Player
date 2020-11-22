import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';

import '../music_util.dart';
import 'controls_util.dart';
import '../sharedPrefs.dart';

class NewAudioControls implements IAudioControls {
  static NewAudioControls _audioControls;
  SharedPrefs _prefs = locator<SharedPrefs>();
  Music _music = locator<IMusic>();
  AssetsAudioPlayer _player;
  int index;

  @override
  PlayerState state;

  @override
  List<String> recent;

  @override
  List<Track> songs;

  static NewAudioControls getInstance() {
    if (_audioControls == null) {
      NewAudioControls placeHolder = NewAudioControls();
      placeHolder.init();
      _audioControls = placeHolder;
    }
    return _audioControls;
  }

  @override
  void init() {
    _player = AssetsAudioPlayer.withId('Music Player');
    songs = _music.songs;
    recent = _prefs.recentlyPlayed.toList();
  }

  Future<void> playinginit() async {
    try {
      await _player.open(
        Audio.file(
          _prefs.currentSong.filePath,
          metas: Metas(
            id: nowPlaying.id,
            title: nowPlaying.title,
            image: nowPlaying.getArtWork() != null
                ? MetasImage.file(nowPlaying.artWork)
                : MetasImage.asset('assets/cd-player.png'),
            onImageLoadFail: MetasImage.asset('assets/cd-player.png'),
          ),
        ),
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
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> playAndPause([isPausebutton = true]) async {
    try {
      if (!isPausebutton) {
        await playinginit();
        await _player.play();
      } else {
        if (state == PlayerState.stop) {
          await playinginit();
          await _player.play();
        } else {
          await _player.playOrPause();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> next() async {
    if (nowPlaying != null) {
      int oldIndex = songs.indexWhere((song) => song.id == nowPlaying.id);
      oldIndex == songs.length - 1 ? index = 0 : index += 1;
      setIndex(songs[index].id);
      await playAndPause(false);
    }
  }

  @override
  Future<void> previous() async {
    index = songs.indexWhere((song) => song.id == nowPlaying.id);
    int oldIndex = songs.indexWhere((song) => song.id == nowPlaying.id);
    oldIndex == 0 ? index = songs.length - 1 : index -= 1;
    setIndex(songs[index].id);
    await playAndPause(false);
  }

  @override
  void toggleRepeat() {
    switch (_prefs.repeat) {
      case 'off':
        _prefs.repeat = 'all';
        break;
      case 'all':
        _prefs.repeat = 'one';
        break;
      case 'one':
        _prefs.repeat = 'off';
        break;
      default:
        _prefs.repeat = 'all';
    }
    print('repeat is ${_prefs.repeat}');
  }

  @override
  void toggleShuffle() {
    if (_prefs.shuffle == true) {
      songs = _music.songs;
      _prefs.shuffle = false;
    } else {
      songs.shuffle();
      _prefs.shuffle = true;
    }
    print('shuffle is ${_prefs.shuffle}');
  }

  @override
  void toggleFav(Track track) {
    List<Track> list = _prefs.favorites;
    List<Track> fav = list.where((element) => element.id == track.id).toList();
    bool checkFav = fav == null || fav.isEmpty ? false : true;
    if (checkFav) {
      list.removeWhere((element) => element.id == track.id);
      _prefs.favorites = list;
    } else {
      list.add(track);
      _prefs.favorites = list;
    }
  }

  @override
  Stream<Track> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield nowPlaying;
    }
  }

  @override
  void setIndex(String id) {
    int songIndex = songs.indexWhere((element) => element.id == id);
    _prefs.currentSong = songs[songIndex];
    index = songIndex;
  }

  @override
  void setRecent(String song) {
    if (_prefs.recentlyPlayed != null) {
      if (_prefs.recentlyPlayed.length < 5) {
        recent = _prefs.recentlyPlayed?.toList();
        if (!_prefs.recentlyPlayed.contains(song)) {
          recent.insert(0, song);
          _prefs.recentlyPlayed = recent.toSet();
        } else {
          recent.removeWhere((element) => element == song);
          recent.insert(0, song);
          _prefs.recentlyPlayed = recent.toSet();
        }
      } else {
        if (!_prefs.recentlyPlayed.contains(song)) {
          recent.removeLast();
          recent.insert(0, song);
          _prefs.recentlyPlayed = recent.toSet();
        } else {
          recent.removeWhere((element) => element == song);
          recent.insert(0, song);
          _prefs.recentlyPlayed = recent.toSet();
        }
      }
    } else {
      recent = [];
      recent.insert(0, song);
      _prefs.recentlyPlayed = recent.toSet();
    }
  }

  @override
  Future<void> setSliderPosition(double val) async {
    await _player.seek(Duration(milliseconds: val.toInt()));
    // print(state);
  }

  Track get nowPlaying => _prefs.currentSong;
  Stream<PlayerState> get stateStream => _player.playerState;
  Stream<RealtimePlayingInfos> get currentSong => _player.realtimePlayingInfos;
  Stream<Duration> get sliderPosition => _player.currentPosition;
}
