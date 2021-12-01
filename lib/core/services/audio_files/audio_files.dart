import 'package:music_player/core/enums/audio_type.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';

abstract class IAudioFiles {
  List<Track>? get songs;
  List<Album>? get albums;
  List<Artist>? get artists;
  List<Track> get favorites;
  List<Track> get currentSongs;

  Future<void> fetchMusic();
  Future<void> fetchAlbums();
  Future<void> fetchArtists();
  Future<List<Track>> fetchMusicFrom(AudioType type, Object query);
  Future<String?> fetchArtWorks(int id, AudioType type);
  Future<void> setFavorite(Track song);
}
