import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';

import 'base_model.dart';

class SongsModel extends BaseModel {
  List<Track> _library = locator<SharedPrefs>().musicList.tracks;

  Stream<List<Track>> get recent async* {
    // await Future.delayed(Duration(seconds: 1));
    notifyListeners();
    yield locator<SharedPrefs>().recentlyPlayed;
  }

  List<Track> get musicList => _library;
}
