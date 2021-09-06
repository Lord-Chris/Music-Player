import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/audio_type.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';


class AlbumsModel extends BaseModel {
  IAudioFiles _library = locator<IAudioFiles>();

  List<Album> get albumList => _library.albums;
  Future <List<Track>> onTap(String id) async {
    return await _library.fetchMusicFrom(AudioType.Album, id);
  }
}
