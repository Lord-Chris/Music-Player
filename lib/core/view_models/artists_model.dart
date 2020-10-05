import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/models/music.dart';

import 'base_model.dart';

class ArtistsModel extends BaseModel {
  Music _library = locator<Music>();

  List<ArtistInfo> get artistList => _library.artists;
  onTap(int index) {
    return _library.getMusicByArtist(artistList[index].id);
  }
}
