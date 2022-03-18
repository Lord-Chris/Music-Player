import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  late List<Track> songsList;
  final _playerService = locator<IPlayerService>();
  final _music = locator<IAudioFileService>();
  final _appAudioService = locator<IAppAudioService>();
  final _audioHandler = locator<AudioHandler>();
  final controller = CarouselController();

  void onModelReady(Track song, bool play) async {
    // init values
    songsList = _appAudioService.currentTrackList;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.jumpToPage(songsList.indexWhere((e) => e == song));
    });
    // play song
    if (play) await _audioHandler.playFromMediaId(song.id!, song.toMap());
    controller.jumpToPage(songsList.indexWhere((e) => e == current!));
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayButtonTap() async {
    if (_playerService.isPlaying) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    await _audioHandler.skipToNext();
    controller.nextPage();
    notifyListeners();
  }

  Future<void> previous() async {
    await _audioHandler.skipToPrevious();
    controller.previousPage();
    notifyListeners();
  }

  String getDuration(Duration duration) {
    String time = duration.toString();
    return GeneralUtils.formatDuration(time);
  }

  Future<void> setSliderPosition(double val) async {
    await _playerService
        .updateSongPosition(Duration(milliseconds: val.toInt()));
    notifyListeners();
  }

  void toggleShuffle() {
    _playerService.toggleShuffle();
    notifyListeners();
  }

  void toggleRepeat() {
    _playerService.toggleRepeat();
    notifyListeners();
  }

  Stream<Duration> get sliderPosition => _playerService.currentDuration;
  bool get isPlaying => _playerService.isPlaying;
  Stream<AppPlayerState> get playerStateStream =>
      _appAudioService.playerStateController.stream;
  double get songDuration => current?.duration?.toDouble() ?? 0;
  Track? get current => _appAudioService.currentTrack;
  bool get shuffle => _playerService.isShuffleOn;
  Repeat get repeat => _playerService.repeatState;
}
