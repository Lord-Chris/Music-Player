import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';

abstract class IAppAudioService {
  StreamController<Duration> get currentTrackDurationController;
  StreamController<AppPlayerState> get playerStateController;
  StreamController<Track> get currentTrackController;
  StreamController<Album> get currentAlbumController;
  StreamController<Artist> get currentArtistController;

  void initialize();
  void dispose();
}
