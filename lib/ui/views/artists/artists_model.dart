import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class ArtistsModel extends BaseModel {
  Music _library = locator<IMusic>();

  List<Artist> get artistList => _library.artists;
  
  Future <List<Track>> onTap(String id) async {
    return await _library.getMusicByArtist(id);
  }
}
