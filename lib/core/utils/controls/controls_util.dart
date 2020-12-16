
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/core/models/track.dart';

abstract class IAudioControls {
  int index;
  List<String> recent;
  // List<Track> songs;
  PlayerState state;

  void init();
  void setIndex(String id);
  Future<void> playAndPause();
  Future<void> next();
  Future<void> previous();
  void toggleShuffle();
  void toggleRepeat();
  void toggleFav(Track track);
  Stream<Track> currentSongStream();
  Future<void> setSliderPosition(double val);
  // void setRecent(String song);
}

// class AudioControls implements IAudioControls {
//   static AudioControls _audioControls;

//   @override
//   int index;

//   @override
//   List<String> _recent;

//   @override
//   List<Track> songs;

//   SharedPrefs _sharedPrefs = locator<SharedPrefs>();
//   AudioPlayer _audioPlayer;
//   AudioPlayerState state;

//   static AudioControls getInstance() {
//     if (_audioControls == null) {
//       AudioControls placeHolder = AudioControls();
//       placeHolder.init();
//       _audioControls = placeHolder;
//     }
//     return _audioControls;
//   }

//   void init() {
//     _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER, playerId: '1');
//     state = AudioPlayerState.STOPPED;
//     songs = _sharedPrefs.musicList;
//     _recent = _sharedPrefs.recentlyPlayed.toList();
//     // setIndex(_sharedPrefs.currentSong?.id);
//   }

//   setRecent(String song) {
//     if (_sharedPrefs.recentlyPlayed != null) {
//       if (_sharedPrefs.recentlyPlayed.length < 5) {
//         _recent = _sharedPrefs.recentlyPlayed?.toList();
//         if (!_sharedPrefs.recentlyPlayed.contains(song)) {
//           _recent.insert(0, song);
//           _sharedPrefs.recentlyPlayed = _recent.toSet();
//         } else {
//           _recent.removeWhere((element) => element == song);
//           _recent.insert(0, song);
//           _sharedPrefs.recentlyPlayed = _recent.toSet();
//         }
//       } else {
//         if (!_sharedPrefs.recentlyPlayed.contains(song)) {
//           _recent.removeLast();
//           _recent.insert(0, song);
//           _sharedPrefs.recentlyPlayed = _recent.toSet();
//         } else {
//           _recent.removeWhere((element) => element == song);
//           _recent.insert(0, song);
//           _sharedPrefs.recentlyPlayed = _recent.toSet();
//         }
//       }
//     } else {
//       _recent = [];
//       _recent.insert(0, song);
//       _sharedPrefs.recentlyPlayed = _recent.toSet();
//     }
//   }

//   void setIndex(String id) {
//     int songIndex = songs.indexWhere((element) => element.id == id);
//     _sharedPrefs.currentSong = songs[index];
//     index = songIndex;
//   }

//   void toggleFav(Track track) {
//     List<Track> list = _sharedPrefs.favorites;
//     List<Track> fav = list.where((element) => element.id == track.id).toList();
//     bool checkFav = fav == null || fav.isEmpty ? false : true;
//     if (checkFav) {
//       list.removeWhere((element) => element.id == track.id);
//       _sharedPrefs.favorites = list;
//     } else {
//       list.add(track);
//       _sharedPrefs.favorites = list;
//     }
//   }

//   Future<void> play() async {
//     try {
//       state = AudioPlayerState.PLAYING;
//       await _audioPlayer.play(_sharedPrefs.currentSong.filePath);
//       print(_sharedPrefs.currentSong.index);
//       setRecent(_sharedPrefs.currentSong.index.toString());
//     } catch (e) {
//       print('play error: $e');
//     }
//   }

//   @override
//   Future<void> next() async {
//     try {
//       if (_sharedPrefs.shuffle)
//         index = Random().nextInt(songs.length);
//       else {
//         index == songs.length - 1 ? index = 0 : index += 1;
//       }
//       await _audioPlayer.stop();
//       await play();
//     } catch (e) {
//       print('next error: $e');
//     }
//   }

//   @override
//   Future<void> playAndPause() async {
//     if (state == AudioPlayerState.PLAYING) {
//       await _audioPlayer.pause();
//       state = AudioPlayerState.PAUSED;
//     } else if (state == AudioPlayerState.PAUSED) {
//       await _audioPlayer.resume();
//       state = AudioPlayerState.PLAYING;
//     } else if (state == AudioPlayerState.COMPLETED ||
//         state == AudioPlayerState.STOPPED) play();
//   }

//   @override
//   Future<void> previous() async {
//     if (_sharedPrefs.shuffle)
//       index = Random().nextInt(songs.length);
//     else {
//       index == 0 ? index = songs.length - 1 : index -= 1;
//     }
//     play();
//   }

//   Stream<Track> currentSongStream() async* {
//     while (true) {
//       await Future.delayed(Duration(milliseconds: 500));
//       yield nowPlaying;
//     }
//   }

//   AudioPlayer get audioPlayer => _audioPlayer;
//   Stream<void> get onCompletion => _audioPlayer.onPlayerCompletion;
//   Stream<Duration> get sliderPosition => _audioPlayer.onAudioPositionChanged;
//   Track get nowPlaying => _sharedPrefs.currentSong;
//   bool get shuffle => _sharedPrefs.shuffle;
//   String get repeat => _sharedPrefs.repeat;

//   @override
//   void toggleRepeat() {
//     // TODO: implement toggleRepeat
//   }

//   @override
//   void toggleShuffle() {
//     // TODO: implement toggleShuffle
//   }

//   @override
//   Future<void> setSliderPosition(double val) {
//     // TODO: implement setSliderPosition
//     throw UnimplementedError();
//   }
// }
