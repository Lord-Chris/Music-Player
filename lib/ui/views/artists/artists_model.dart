import 'package:musicool/app/locator.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class ArtistsModel extends BaseModel {
  final _library = locator<IAudioFiles>();

  List<Artist> get artistList => _library.artists!;

  Future<List<Track>> onTap(Artist artist) async {
    final _tracks = _library.songs!
        .where((element) => artist.trackIds!.contains(element.id))
        .toList();
    return _tracks;
  }
}
