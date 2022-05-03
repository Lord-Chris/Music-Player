import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  List<Track> songsList = [];
  final _playerService = locator<IPlayerService>();
  final _music = locator<IAudioFileService>();
  final _appAudioService = locator<IAppAudioService>();
  final _audioHandler = locator<AudioHandler>();
  final _log = Logger();
  late final PageController pageController;

  void _animateToPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void onModelReady(Track track, bool play) async {
    try {
      // init values
      songsList = _appAudioService.currentTrackList.isEmpty
          ? _music.songs!
          : _appAudioService.currentTrackList;
      pageController = PageController(
          initialPage: songsList.indexWhere((e) => e.id == track.id),
          viewportFraction: 0.8);

      // play track
      if (play) await _audioHandler.playFromMediaId(track.id, track.toMap());
    } catch (e) {
      _log.e(e.toString());
    }
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayingArtChanged(int page) {
    final track = songsList[page];
    _audioHandler.playFromMediaId(track.id, track.toMap());
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
    _animateToPage(_index + 1);
    await _audioHandler.skipToNext();
    notifyListeners();
  }

  Future<void> previous() async {
    _animateToPage(_index - 1);
    await _audioHandler.skipToPrevious();
    notifyListeners();
  }

  String getDuration(Duration duration) {
    String time = duration.toString();
    return GeneralUtils.formatDuration(time);
  }

  Future<void> setSliderPosition(double val) async {
    final _pos = (val * (songDuration ?? 0)).toInt();
    _playerService.updateSongPosition(Duration(milliseconds: _pos));
  }

  Future<void> toggleShuffle() async {
    await _playerService.toggleShuffle();
    pageController.jumpToPage(_index);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    await _playerService.toggleRepeat();
    notifyListeners();
  }

  int get _index => songsList.indexWhere((e) => e.id == current?.id);
  Stream<Duration> get sliderPosition => _playerService.currentDuration;
  bool get isPlaying => _playerService.isPlaying;
  Stream<AppPlayerState> get playerStateStream =>
      _appAudioService.playerStateController.stream;
  double? get songDuration => current?.duration?.ceilToDouble();
  Track? get current => _appAudioService.currentTrack;
  bool get shuffle => _playerService.isShuffleOn;
  Repeat get repeat => _playerService.repeatState;
}
