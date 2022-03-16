import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';

abstract class IAppAudioService implements IService {
  Track? get currentTrack;
  AppPlayerState get playerState;
  StreamController<AppPlayerState> get playerStateController;
  StreamController<Track?> get currentTrackController;
  StreamController<Album?> get currentAlbumController;
  StreamController<Artist?> get currentArtistController;
}
