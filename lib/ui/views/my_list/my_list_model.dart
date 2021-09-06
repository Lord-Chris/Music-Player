import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class MyListModel extends BaseModel {
  IAudioControls _controls = locator<IAudioControls>();
  Track? get nowPlaying => locator<SharedPrefs>().getCurrentSong();
  Stream<Track> get nowPlayingStream => _controls.currentSongStream();
}
