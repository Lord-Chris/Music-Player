import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/view_models/base_model.dart';

import '../locator.dart';

class AlbumsModel extends BaseModel {
  Music _library = locator<Music>();

  List<AlbumInfo> get albumList => _library.albums;
  onTap(int index) {
    return _library.getMusicByAlbum(albumList[index].id);
  }
}
