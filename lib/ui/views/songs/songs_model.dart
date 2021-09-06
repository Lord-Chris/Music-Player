import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class SongsModel extends BaseModel {
  IAudioFiles _music = locator<IAudioFiles>();
  // List<Track> _recentlyPlayed;
  // Stream<List<Track>> recent() async* {
  //   while (true) {
  //      _recentlyPlayed = [];
  //     await Future.delayed(Duration(milliseconds: 500));
  //     if (locator<SharedPrefs>().recentlyPlayed != null)
  //       for (String index in locator<SharedPrefs>().recentlyPlayed?.toList()) {
  //         _recentlyPlayed.add(musicList[int.parse(index)]);
  //       }
  //     yield _recentlyPlayed;
  //   }
  // }

  List<Track> get musicList => _music.songs;
}
