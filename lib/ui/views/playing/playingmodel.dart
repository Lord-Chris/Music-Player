import 'dart:convert';

import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/core/utils/general_utils.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  late Track _current;
  late List<Track> songsList;
  IPlayerControls _controls = locator<IPlayerControls>();
  IAudioFiles _music = locator<IAudioFiles>();
  SharedPrefs _prefs = locator<SharedPrefs>();

  void onModelReady(Track song, bool play,
      [List<Track>? newList, bool? changeList]) async {
    // init values
    _current = song;

    if (changeList == true) {
      if (newList == null) {
        print('REMOVING DATA');
        await _prefs.removedata(CURRENTSONGLIST);
      } else {
        // assert(newList != null);
        print("CHANGING CURRENT LIST");
        await _prefs.saveStringList(CURRENTSONGLIST,
            newList.map((e) => jsonEncode((e.toMap()))).toList());
      }
    }
    songsList =
        _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

    // play song
    // _controls.songs = newList ?? list;
    // await _controls.setIndex(id);
    if (play) await _controls.play(song.filePath!);
    _current = current!;
  }

  bool checkFav() {
    bool isFav = fav.any((e) => e.id == current!.id);
    return isFav;
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayButtonTap() async {
    if (_controls.isPlaying) {
      await _controls.pause();
    } else {
      await _controls.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    int res = songsList.indexWhere((e) => e.id == current!.id);
    _current = await _controls.playNext(res, songsList);
    notifyListeners();
  }

  Future<void> previous() async {
    int res = songsList.indexWhere((e) => e.id == current!.id);
    _current = await _controls.playPrevious(res, songsList);
    notifyListeners();
  }

  String getDuration(Duration duration) {
    String time = duration.toString();
    return GeneralUtils.formatDuration(time);
  }

  Future<void> setSliderPosition(double val) async {
    await _controls.updateSongPosition(Duration(milliseconds: val.toInt()));
    notifyListeners();
  }

  void toggleShuffle() {
    _controls.toggleShuffle();
    notifyListeners();
  }

  void toggleRepeat() {
    _controls.toggleRepeat(repeat);
    notifyListeners();
  }

  // PlayerState get state => _controls.state;
  Stream<Duration> get sliderPosition => _controls.currentDuration;
  bool get isPlaying => _controls.isPlaying;
  double get songDuration => current?.duration?.toDouble() ?? 0;
  Track? get current => _controls.getCurrentTrack();
  bool get shuffle => _controls.isShuffleOn;
  Repeat get repeat => _controls.repeatState;
  // List<Track> get list => _music.songs;
  List<Track> get fav => _music.favorites;
}
