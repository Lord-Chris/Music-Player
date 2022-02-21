import 'package:musicool/app/locator.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class AlbumsModel extends BaseModel {
  final _library = locator<IAudioFiles>();

  List<Album> get albumList => _library.albums!;

  Future<List<Track>> onTap(Album album) async {
    print(album.trackIds);
    final _tracks = _library.songs!
        .where((element) => album.trackIds!.contains(element.id))
        .toList();
    return _tracks;
  }
}
