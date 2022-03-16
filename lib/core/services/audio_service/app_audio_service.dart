import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/ui/constants/_constants.dart';

import '../_services.dart';

class AppAudioService extends IAppAudioService {
  final _localStorage = locator<ILocalStorageService>();

  // Stream Controllers
  final _currentTrackDurationController =
      StreamController<Duration>.broadcast();
  final _playerStateController = StreamController<AppPlayerState>.broadcast();
  final _currentTrackController = StreamController<Track>.broadcast();
  final _currentAlbumController = StreamController<Album>.broadcast();
  final _currentArtistController = StreamController<Artist>.broadcast();

  // Stream Subscriptions
  late StreamSubscription<AppPlayerState> _playerStateSub;

  @override
  void initialize() {
    _subscriptionInit();
  }

  @override
  void dispose() {
    _currentTrackDurationController.close();
    _playerStateController.close();
    _currentTrackController.close();
    _currentAlbumController.close();
    _currentArtistController.close();

    _playerStateSub.cancel();
  }

  void _subscriptionInit() {
    _playerStateSub =
        _playerStateController.stream.listen(_onPlayerStateChange);
  }

  void _onPlayerStateChange(AppPlayerState state) {
    _localStorage.writeToBox(PLAYER_STATE, state);
    print("CURRENT PLAYER STATE: $state");

    // List<Track> list;
    // // if (data != _playerService.playerState) {
    // //   await _playerService.updatePlayerState(data);
    // list = _playerService.getCurrentListOfSongs();

    // if (state == AppPlayerState.Finished) {
    //   if (_playerService.repeatState == Repeat.One) {
    //     _playerService.play();
    //   } else if (_playerService.repeatState == Repeat.All) {
    //     _playerService.playNext();
    //   } else if (_playerService.repeatState == Repeat.Off &&
    //       _playerService.getCurrentTrack()!.index! != list.length - 1) {
    //     _playerService.play();
    //   }
    // }
    // // }
  }

  @override
  StreamController<Album> get currentAlbumController => _currentAlbumController;

  @override
  StreamController<Artist> get currentArtistController =>
      _currentArtistController;

  @override
  StreamController<Track> get currentTrackController => _currentTrackController;

  @override
  StreamController<Duration> get currentTrackDurationController =>
      _currentTrackDurationController;

  @override
  StreamController<AppPlayerState> get playerStateController =>
      _playerStateController;
}
