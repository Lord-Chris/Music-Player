import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';

class ClassUtil {
  static Track toTrack(SongInfo song, int index) {
    return Track(
      id: song.id,
      title: song.title,
      album: song.album,
      artist: song.artist,
      artWork: song.albumArtwork,
      displayName: song.displayName,
      duration: song.duration,
      size: song.fileSize,
      filePath: song.filePath,
      index: index,
    );
  }

  static Album toAlbum(AlbumInfo album, int index) {
    return Album(
      id: album.id,
      title: album.title,
      artwork: album.albumArt,
      numberOfSongs: album.numberOfSongs,
      index: index,
    );
  }

  static Artist toArtist(ArtistInfo artist, int index) {
    return Artist(
      id: artist.id,
      name: artist.name,
      artwork: artist.artistArtPath,
      numberOfSongs: artist.numberOfTracks,
      numberOfAlbums: artist.numberOfAlbums,
      index: index,
    );
  }
}
