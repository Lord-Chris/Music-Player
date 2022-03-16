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

  // Stream Subscriptions
  late StreamSubscription<AppPlayerState> _playerStateSub;
  late StreamSubscription<Track?> _currentTrackSub;

  // Others
  Track? _track;
  AppPlayerState? _playerState;

  @override
  void initialize() {
    _controllerInit();
    _subscriptionInit();
    _dataInit();
  }

  @override
  void dispose() {
    _playerStateController.close();
    _currentTrackController.close();
    _currentAlbumController.close();
    _currentArtistController.close();

    _playerStateSub.cancel();
    _currentTrackSub.cancel();
  }

  void _controllerInit() {
    _playerStateController =
        StreamController<AppPlayerState>.broadcast(sync: true);
    _currentTrackController = StreamController<Track?>.broadcast(sync: true);
    _currentAlbumController = StreamController<Album?>.broadcast(sync: true);
    _currentArtistController = StreamController<Artist?>.broadcast(sync: true);
  }

  void _dataInit() {
    final _trackList =
        _localStorage.getFromBox<List>(MUSICLIST, def: []).cast<Track?>();
    dynamic current =
        _trackList.firstWhere((e) => e?.isPlaying ?? false, orElse: () => null);
    _currentTrackController.add(current);

    final _albumList =
        _localStorage.getFromBox<List>(ALBUMLIST, def: []).cast<Album?>();
    current =
        _albumList.firstWhere((e) => e?.isPlaying ?? false, orElse: () => null);
    _currentAlbumController.add(current);

    final _artistList =
        _localStorage.getFromBox<List>(ARTISTLIST, def: []).cast<Artist?>();
    current = _artistList.firstWhere((e) => e?.isPlaying ?? false,
        orElse: () => null);
    _currentArtistController.add(current);
  }

  void _subscriptionInit() {
    _playerStateSub =
        _playerStateController.stream.listen(_onPlayerStateChange);
    _currentTrackSub = _currentTrackController.stream.listen((event) {
      if (event != currentTrack) {
        _track = event;
      }
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
}
