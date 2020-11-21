import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/base_model.dart';

import '../locator.dart';

class MyListModel extends BaseModel {
  IAudioControls stuff = locator<IAudioControls>();
  Track get nowPlaying => locator<SharedPrefs>().currentSong;
  Stream<Track> get nowPlayingStream => stuff.currentSongStream();
}
