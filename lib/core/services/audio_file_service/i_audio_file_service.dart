import 'dart:typed_data';

import 'package:musicool/core/enums/audio_type.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/models/track.dart';

abstract class IAudioFileService {
  List<Track>? get songs;
  List<Album>? get albums;
  List<Artist>? get artists;
  List<Track> get favourites;

  Future<void> fetchMusic();
  Future<void> fetchAlbums();
  Future<void> fetchArtists();
  Future<List<Track>> fetchMusicFrom(AudioType type, Object query);
  Future<Uint8List?> fetchArtWorks(int id, AudioType type);
  Future<void> setFavorite(Track song);
  Future<void> clearFavourites();
}
