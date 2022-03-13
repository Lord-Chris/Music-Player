import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  late List<Track> songsList;
  final _controls = locator<IPlayerService>();
  final _music = locator<IAudioFileService>();
  final _handler = locator<AudioHandler>();
  final controller = CarouselController();

  void onModelReady(Track song, bool play) async {
    // init values
    songsList = _controls.getCurrentListOfSongs();

    // play song
    if (play) {
      await _handler.playFromMediaId("${song.id}", {'path': song.filePath!});
    }
    notifyListeners();
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayButtonTap() async {
    if (_controls.isPlaying) {
      await _handler.pause();
    } else {
      await _handler.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    await _handler.skipToNext();
    controller.nextPage();
    notifyListeners();
  }

  Future<void> previous() async {
    await _handler.skipToPrevious();
    controller.previousPage();
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

  Stream<Duration> get sliderPosition => _controls.currentDuration;
  bool get isPlaying => _controls.isPlaying;
  Stream<AppPlayerState> get playerStateStream => _controls.playerStateStream;
  double get songDuration => current?.duration?.toDouble() ?? 0;
  Track? get current => _controls.getCurrentTrack();
  bool get shuffle => _controls.isShuffleOn;
  Repeat get repeat => _controls.repeatState;
}
