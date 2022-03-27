import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/constants/_constants.dart';

import '../_services.dart';

class AppAudioService extends IAppAudioService {
  final _localStorage = locator<ILocalStorageService>();

  // Stream Controllers
  late final StreamController<AppPlayerState> _playerStateController;
  late final StreamController<Track?> _currentTrackController;
  late final StreamController<Album?> _currentAlbumController;
  late final StreamController<Artist?> _currentArtistController;
  late final StreamController<List<Track>> _currentTrackListController;

  // Stream Subscriptions
  late StreamSubscription<AppPlayerState> _playerStateSub;
  late StreamSubscription<Track?> _currentTrackSub;
  late StreamSubscription<List<Track?>> _currentTrackListSub;

  // Others
  Track? _track;
  AppPlayerState? _playerState;
  List<Track> _trackList = [];

  @override
  void initialize() {
    _controllerInit();
    _subscriptionInit();
    _dataInit();
  }

  @override
  void pause() {
    // _playerStateSub.pause();
    // _currentTrackSub.pause();
    _currentTrackListSub.pause();
  }

  @override
  void resume() {
    // _playerStateSub.resume();
    // _currentTrackSub.resume();
    _currentTrackListSub.resume();
  }

  @override
  void dispose() {
    _playerStateController.close();
    _currentTrackController.close();
    _currentAlbumController.close();
    _currentArtistController.close();
    _currentTrackListController.close();

    _playerStateSub.cancel();
    _currentTrackSub.cancel();
    _currentTrackListSub.cancel();
  }

  void _controllerInit() {
    _playerStateController = StreamController<AppPlayerState>.broadcast();
    _currentTrackController = StreamController<Track?>.broadcast();
    _currentAlbumController = StreamController<Album?>.broadcast();
    _currentArtistController = StreamController<Artist?>.broadcast();
    _currentTrackListController = StreamController<List<Track>>.broadcast();
  }

  void _dataInit() {
    // Track
    final _trackList =
        _localStorage.getFromBox<List>(MUSICLIST, def: []).cast<Track?>();
    dynamic current =
        _trackList.firstWhere((e) => e?.isPlaying ?? false, orElse: () => null);
    _currentTrackController.add(current);

    final _currenttrackList = _localStorage
        .getFromBox<List>(CURRENTTRACKLIST, def: _trackList)
        .cast<Track>();
    _currentTrackListController.add(_currenttrackList);

    // Album
    final _albumList =
        _localStorage.getFromBox<List>(ALBUMLIST, def: []).cast<Album?>();
    current =
        _albumList.firstWhere((e) => e?.isPlaying ?? false, orElse: () => null);
    _currentAlbumController.add(current);

    // Artist
    final _artistList =
        _localStorage.getFromBox<List>(ARTISTLIST, def: []).cast<Artist?>();
    current = _artistList.firstWhere((e) => e?.isPlaying ?? false,
        orElse: () => null);
    _currentArtistController.add(current);

    // Player State
    final _state = _localStorage.getFromBox<AppPlayerState>(PLAYER_STATE,
        def: AppPlayerState.Idle);
    _playerStateController.add(_state);
  }

  void _subscriptionInit() {
    _playerStateSub =
        _playerStateController.stream.listen(_onPlayerStateChange);
    _currentTrackSub = _currentTrackController.stream.listen((event) {
      if (event != currentTrack) _track = event;
    });
    _currentTrackListSub = _currentTrackListController.stream.listen((event) {
      if (event != _trackList) _trackList = event;
    });
  }

  void _onPlayerStateChange(AppPlayerState state) {
    if (state != _playerState) {
      _localStorage.writeToBox(PLAYER_STATE, state);
      _playerState = state;
      print("CURRENT PLAYER STATE: $state");
    }
  }

  @override
  Track? get currentTrack => _track;

  @override
  List<Track> get currentTrackList => _trackList;

  @override
  AppPlayerState get playerState =>
      _playerState ??
      _localStorage.getFromBox(PLAYER_STATE, def: AppPlayerState.Idle);

  @override
  StreamController<Album?> get currentAlbumController =>
      _currentAlbumController;

  @override
  StreamController<Artist?> get currentArtistController =>
      _currentArtistController;

  @override
  StreamController<Track?> get currentTrackController =>
      _currentTrackController;

  @override
  StreamController<AppPlayerState> get playerStateController =>
      _playerStateController;

  @override
  StreamController<List<Track>> get currentTrackListController =>
      _currentTrackListController;
}
