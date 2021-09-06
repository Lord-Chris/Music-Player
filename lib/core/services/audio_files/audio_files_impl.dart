import 'package:music_player/core/models/track.dart';

import 'package:music_player/core/models/artists.dart';

import 'package:music_player/core/models/albums.dart';

import 'audio_files.dart';

class AudioFilesImpl implements IAudioFiles {
  @override
  // TODO: implement albums
  List<Album> get albums => throw UnimplementedError();

  @override
  // TODO: implement artists
  List<Artist> get artists => throw UnimplementedError();

  @override
  Future<void> fetchAlbums() async {
    // TODO: implement fetchAlbums
  }

  @override
  Future<void> fetchArtists() async {
    // TODO: implement fetchArtists
  }

  @override
  Future<void> fetchMusic() async {
    // TODO: implement fetchMusic
  }

  @override
  // TODO: implement songs
  List<Track> get songs => [];

}
