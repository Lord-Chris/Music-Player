import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import 'base_model.dart';

class SongsModel extends BaseModel {
  Stream<List<Track>> recent() async* {
    while (true) {
      List<Track> _recentlyPlayed = [];
      await Future.delayed(Duration(milliseconds: 500));
      if (locator<SharedPrefs>().recentlyPlayed != null)
        for (String index in locator<SharedPrefs>().recentlyPlayed?.toList()) {
          _recentlyPlayed.add(musicList[int.parse(index)]);
        }
      yield _recentlyPlayed;
    }
  }

  Stream<String> musicId() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield controls.nowPlaying?.id;
    }
  }

  AudioControls get controls => locator<AudioControls>();
  List<Track> get musicList => locator<SharedPrefs>().musicList.tracks;
}
