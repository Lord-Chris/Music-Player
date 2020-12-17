import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/new_controls_utils.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  NewAudioControls _controls = locator<IAudioControls>();
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  Music _music = locator<IMusic>();

  void onModelReady(String id, bool play, [List<Track> newList]) async {
    _controls.songs = newList ?? list;
    await _controls.setIndex(id);
    if (play) await _controls.playAndPause(true);
  }

  bool checkFav() {
    List<Track> list =
        fav.where((element) => element.id == nowPlaying.id).toList();
    return list == null || list.isEmpty ? false : true;
  }

  void toggleFav() {
    _controls.toggleFav(nowPlaying);
    notifyListeners();
  }

  void onPlayButtonTap() async {
    await _controls.playAndPause();
    notifyListeners();
  }

  Future<void> next() async {
    await _controls.next();
    notifyListeners();
  }

  Future<void> previous() async {
    await _controls.previous();
    notifyListeners();
  }

  String getDuration({Duration duration}) {
    String time = duration.toString();
    return convertToString(time);
  }

  String convertToString(String time) {
    int len = time.length;
    if (len == 14 && time[0] != '0')
      return time.substring(0, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] == '0')
      return time.substring(3, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] != '0')
      return time.substring(2, len - 7);
    else
      return '0:00';
  }

  Future<void> setSliderPosition(double val) async {
    await _controls.setSliderPosition(val);
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

  PlayerState get state => _controls.state;
  Stream<Duration> get sliderPosition => _controls.sliderPosition;

  double get songDuration =>
      double.parse(_sharedPrefs.currentSong?.duration ?? '0') ?? 0;
  Track get nowPlaying => _sharedPrefs.currentSong;
  bool get shuffle => _sharedPrefs.readBool(SHUFFLE,def: false);
  String get repeat => _sharedPrefs.repeat;
  List<Track> get list => _music.songs;
  List<Track> get fav => locator<SharedPrefs>().favorites;
}
