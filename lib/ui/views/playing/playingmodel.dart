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
  late PageController pageController;
  late StreamSubscription<AppPlayerState> _stateSub;

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
      _initPageController(track);
      // play track
      if (play) await _audioHandler.playFromMediaId(track.id, track.toMap());
    } catch (e) {
      _log.e(e.toString());
    }
  }

  void _initPageController(Track track) {
    pageController = PageController(
        initialPage: songsList.indexWhere((e) => e.id == track.id),
        viewportFraction: 0.8);
    _stateSub = playerStateStream.listen((event) {
      if (event == AppPlayerState.Finished) {
        if (_playerService.repeatState == Repeat.One) {
        } else if (_playerService.repeatState == Repeat.All) {
          _animateToPage(index + 1 > songsList.length - 1 ? 0 : index + 1);
        } else if (_playerService.repeatState == Repeat.Off &&
            _appAudioService.currentTrack! != songsList.last) {
          _animateToPage(index + 1);
        }
      }
    });
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayingArtChanged(int page) {
    final track = songsList[page];
    if (page != index) _audioHandler.playFromMediaId(track.id, track.toMap());
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
    _animateToPage(index + 1 > songsList.length - 1 ? 0 : index + 1);
    notifyListeners();
  }

  Future<void> previous() async {
    await _audioHandler.skipToPrevious();
    _animateToPage(index - 1 < 0 ? songsList.length - 1 : index - 1);
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
    pageController.jumpToPage(index);
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    await _playerService.toggleRepeat();
    notifyListeners();
  }

  @override
  void dispose() {
    _stateSub.cancel();
    pageController.dispose();
    super.dispose();
  }

  int get index => songsList.indexWhere((e) => e.id == current?.id);
  Stream<Duration> get sliderPosition => _playerService.currentDuration;
  bool get isPlaying => _playerService.isPlaying;
  Stream<AppPlayerState> get playerStateStream =>
      _appAudioService.playerStateController.stream;
  double? get songDuration => current?.duration?.ceilToDouble();
  Track? get current => _appAudioService.currentTrack;
  bool get shuffle => _playerService.isShuffleOn;
  Repeat get repeat => _playerService.repeatState;
}
