import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import '../locator.dart';

// class NewAudioControls implements IAudioControls {
//   AssetsAudioPlayer _player = AssetsAudioPlayer.withId('Music Player');
//   SharedPrefs _prefs = locator<SharedPrefs>();
//   List<Track> _songs;
//   Track nowPlaying;
//   int _index;
//   @override
//   Future<void> init() async {
//     await _player.open(
//       Audio.file(
//         nowPlaying.id,
//         metas: Metas(
//           id: nowPlaying.id,
//           title: nowPlaying.title,
//           image: MetasImage.file(nowPlaying.artWork),
//           onImageLoadFail: MetasImage.asset('assets/cd-player.png'),
//         ),
//       ),
//       headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//       playInBackground: PlayInBackground.enabled,
//       respectSilentMode: true,
//       showNotification: true,
//       notificationSettings: NotificationSettings(
//         nextEnabled: true,
//         prevEnabled: true,
//         playPauseEnabled: true,
//         customNextAction: (player) {},
//         customPrevAction: (player) {},
//       ),
//     );
//   }

//   @override
//   Future<void> playPause() async {
//     nowPlaying = _prefs.currentSong;
//     await init();
//     await _player.play();
//     print('Playing ...\n${nowPlaying.title}');
//   }

//   @override
//   Future<void> next() async {
//     _index = _songs.indexWhere((song) => song.id == nowPlaying.id) + 1;
//     nowPlaying = _songs[_index];
//     await playPause();
//   }

//   @override
//   Future<void> previous() async {
//     _index = _songs.indexWhere((song) => song.id == nowPlaying.id) - 1;
//     nowPlaying = _songs[_index];
//     await playPause();
//   }

//   @override
//   void toggleRepeat() {
//     switch (_prefs.repeat) {
//       case 'off':
//         _prefs.repeat = 'all';
//         break;
//       case 'all':
//         _prefs.repeat = 'all';
//         break;
//       case 'one':
//         _prefs.repeat = 'all';
//         break;
//       default:
//         _prefs.repeat = 'all';
//     }
//     print('repeat is ${_prefs.shuffle}');
//   }

//   @override
//   void toggleShuffle() {
//     if (_prefs.shuffle == true) {
//       _songs.shuffle();
//       _prefs.shuffle = false;
//     } else {
//       _songs = _prefs.musicList;
//       _prefs.shuffle = true;
//     }
//     print('shuffle is ${_prefs.shuffle}');
//   }
// }
abstract class IAudioControls {
  void init();
  Future<void> playAndPause();
  Future<void> next();
  Future<void> previous();
  // void toggleShuffle();
  // void toggleRepeat();
  Stream<Track> currentSongStream();
}

class AudioControls implements IAudioControls {
  static AudioControls _audioControls;

  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  List<Track> songs;
  AudioPlayer _audioPlayer;
  AudioPlayerState state;
  int _index;
  List<String> _recent;

  static AudioControls getInstance() {
    if (_audioControls == null) {
      AudioControls placeHolder = AudioControls();
      placeHolder.init();
      _audioControls = placeHolder;
    }
    return _audioControls;
  }

  void init() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
    state = AudioPlayerState.STOPPED;
    songs = _sharedPrefs.musicList;
    _recent = _sharedPrefs.recentlyPlayed.toList();
  }

  set index(int index) {
    _sharedPrefs.currentSong = songs[index];
    _index = index;
  }

  set recent(String song) {
    if (_sharedPrefs.recentlyPlayed != null) {
      if (_sharedPrefs.recentlyPlayed.length < 5) {
        _recent = _sharedPrefs.recentlyPlayed?.toList();
        if (!_sharedPrefs.recentlyPlayed.contains(song)) {
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
        } else {
          _recent.removeWhere((element) => element == song);
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
        }
      } else {
        if (!_sharedPrefs.recentlyPlayed.contains(song)) {
          _recent.removeLast();
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
        } else {
          _recent.removeWhere((element) => element == song);
          _recent.insert(0, song);
          _sharedPrefs.recentlyPlayed = _recent.toSet();
        }
      }
    } else {
      _recent = [];
      _recent.insert(0, song);
      _sharedPrefs.recentlyPlayed = _recent.toSet();
    }
  }

  void setIndex(String id) {
    int songIndex = songs.indexWhere((element) => element.id == id);
    index = songIndex;
  }

  void toggleFav(Track track) {
    // print(
    //     '${songs.sublist(0, 5)} + ${state.toString()} + ${_audioPlayer.playerId}');
    List<Track> list = _sharedPrefs.favorites;
    List<Track> fav = list.where((element) => element.id == track.id).toList();
    bool checkFav = fav == null || fav.isEmpty ? false : true;
    // print(list);
    if (checkFav) {
      list.removeWhere((element) => element.id == track.id);
      _sharedPrefs.favorites = list;
    } else {
      list.add(track);
      _sharedPrefs.favorites = list;
    }
  }

  Future<void> play() async {
    try {
      state = AudioPlayerState.PLAYING;
      await _audioPlayer.play(_sharedPrefs.currentSong.filePath);
      print(_sharedPrefs.currentSong.index);
      recent = _sharedPrefs.currentSong.index.toString();
    } catch (e) {
      print('play error: $e');
    }
  }

  Future<void> next() async {
    try {
      if (_sharedPrefs.shuffle)
        index = Random().nextInt(songs.length);
      else {
        index == songs.length - 1 ? index = 0 : index += 1;
      }
      await _audioPlayer.stop();
      await play();
    } catch (e) {
      print('next error: $e');
    }
  }

  @override
  Future<void> playAndPause() async {
    if (state == AudioPlayerState.PLAYING) {
      await _audioPlayer.pause();
      state = AudioPlayerState.PAUSED;
    } else if (state == AudioPlayerState.PAUSED) {
      await _audioPlayer.resume();
      state = AudioPlayerState.PLAYING;
    } else if (state == AudioPlayerState.COMPLETED ||
        state == AudioPlayerState.STOPPED) play();
  }

  Future<void> previous() async {
    if (_sharedPrefs.shuffle)
      index = Random().nextInt(songs.length);
    else {
      index == 0 ? index = songs.length - 1 : index -= 1;
    }
    play();
  }

  Stream<Track> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield nowPlaying;
    }
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  int get index => _index;
  Stream<void> get onCompletion => _audioPlayer.onPlayerCompletion;
  Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
  Track get nowPlaying => _sharedPrefs.currentSong;
  bool get shuffle => _sharedPrefs.shuffle;
  String get repeat => _sharedPrefs.repeat;
}
