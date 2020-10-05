import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/models/track.dart';

import 'base_model.dart';

class SongsModel extends BaseModel {
  Music _library = locator<Music>();

  List<Track> get musicList => _library.songs;
}
