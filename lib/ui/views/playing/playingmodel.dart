// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/core/utils/general_utils.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  late Track _current;
  late List<Track> songsList;
  IPlayerControls _controls = locator<IPlayerControls>();
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
    bool isFav = fav.any((e) => e.id == _current.id);
    return isFav;
  }

  void toggleFav() {
    _music.setFavorite(current);
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
    _controls.toggleRepeat(repeat);
    notifyListeners();
  }

  // PlayerState get state => _controls.state;
  Stream<Duration> get sliderPosition => _controls.currentDuration;
  bool get isPlaying => _controls.isPlaying;
  double get songDuration => _current.duration!.toDouble();
  Track get current => _current;
  bool get shuffle => _controls.isShuffleOn;
  Repeat get repeat => _controls.repeatState;
  // List<Track> get list => _music.songs;
  List<Track> get fav => _music.favorites;
}
