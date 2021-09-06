import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';

abstract class IAudioFiles {
  List<Track> get songs;
  List<Album> get albums;
  List<Artist> get artists;

  Future<void> fetchMusic();
  Future<void> fetchAlbums();
  Future<void> fetchArtists();
}
