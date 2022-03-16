import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';

abstract class IAppAudioService {
  Track? get currentTrack;
  AppPlayerState get playerState;
  void initialize();
  void pause();
  void resume();
  void dispose();
  StreamController<AppPlayerState> get playerStateController;
  StreamController<Track?> get currentTrackController;
  StreamController<Album?> get currentAlbumController;
  StreamController<Artist?> get currentArtistController;
}
