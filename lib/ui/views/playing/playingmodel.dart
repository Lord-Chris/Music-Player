// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
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
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  IAudioFiles _music = locator<IAudioFiles>();

  void onModelReady(Track song, bool play, [List<Track>? newList]) async {
    // init values
    _current = song;
    songsList = newList ?? _music.songs;

    // play song
    // _controls.songs = newList ?? list;
    // await _controls.setIndex(id);
    if (play) await _controls.play(song.filePath!);
  }

  bool checkFav() {
    List<Track> list =
        fav.where((element) => element.id == _current.id).toList();
    return list == null || list.isEmpty ? false : true;
  }

  void toggleFav() {
    // _controls.toggleFav(nowPlaying!);
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
    int res = songsList.indexWhere((e) => e.id == _current.id);
    _current = await _controls.playNext(res, songsList);
    notifyListeners();
  }

  Future<void> previous() async {
    int res = songsList.indexWhere((e) => e.id == _current.id);
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
    _controls.toggleRepeat();
    notifyListeners();
  }

  // PlayerState get state => _controls.state;
  Stream<Duration> get sliderPosition => _controls.currentDuration;
  bool get isPlaying => _controls.isPlaying;
  double get songDuration => _current.duration!.toDouble();
  // _sharedPrefs.getCurrentSong()?.duration?.toDouble() ?? 0;
  Track get current => _current;
  bool? get shuffle => _sharedPrefs.readBool(SHUFFLE, def: false);
  String? get repeat => _sharedPrefs.readString(REPEAT, def: 'off');
  // List<Track> get list => _music.songs;
  List<Track> get fav => _sharedPrefs.getfavorites();
}
