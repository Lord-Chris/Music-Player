import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import 'base_model.dart';

class SongsModel extends BaseModel {
  List<Track> _recentlyPlayed;
  Stream<List<Track>> recent() async* {
    while (true) {
       _recentlyPlayed = [];
      await Future.delayed(Duration(milliseconds: 500));
      if (locator<SharedPrefs>().recentlyPlayed != null)
        for (String index in locator<SharedPrefs>().recentlyPlayed?.toList()) {
          _recentlyPlayed.add(musicList[int.parse(index)]);
        }
      yield _recentlyPlayed;
    }
  }

  List<Track> get musicList => locator<SharedPrefs>().musicList;
}
