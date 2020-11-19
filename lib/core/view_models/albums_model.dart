import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/view_models/base_model.dart';

import '../locator.dart';

class AlbumsModel extends BaseModel {
  Music _library = locator<Music>();

  List<Album> get albumList => _library.albums;
  Future <List<Track>> onTap(String id) async {
    return await _library.getMusicByAlbum(id);
  }
}
