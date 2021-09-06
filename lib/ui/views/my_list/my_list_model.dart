import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class MyListModel extends BaseModel {
  IPlayerControls _controls = locator<IPlayerControls>();
  // Track? get nowPlaying => locator<SharedPrefs>().getCurrentSong();
  // Stream<Track> get nowPlayingStream => _controls.currentSongStream();
}
