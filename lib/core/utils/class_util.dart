// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:music_player/core/models/albums.dart';
import 'package:music_player/core/models/artists.dart';
import 'package:music_player/core/models/track.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ClassUtil {
  static Track toTrack(SongModel song, int index) {
    return Track(
      id: song.id.toString(),
      title: song.title,
      album: song.album,
      artist: song.artist,
      artWork: song.data,
      displayName: song.displayName,
      duration: song.duration,
      size: song.size,
      filePath: song.data,
      index: index,
    );
  }

//   static Album toAlbum(AlbumInfo album, int index) {
//     return Album(
//       id: album.id,
//       title: album.title,
//       artwork: album.albumArt,
//       numberOfSongs: album.numberOfSongs,
//       index: index,
//     );
//   }

  static Artist toArtist(ArtistModel artist, int index) {
    return Artist(
      id: artist.id.toString(),
      name: artist.artist,
      // artwork: artist.,
      numberOfSongs: artist.numberOfTracks,
      numberOfAlbums: artist.numberOfAlbums,
      index: index,
    );
  }

//   static Audio toAudio(Track song) {
//     return Audio.file(
//       song.filePath,
//       metas: Metas(
//         id: song.id,
//         title: song.title,
//         artist: song.artist,
//         album: song.album,
//         image: MetasImage.file(song.getArtWork()),
//         onImageLoadFail: MetasImage.asset('assets/cd-player.png'),
//       ),
//     );
//   }
//   // StreamTransformer<RealtimePlayingInfos, Track> transformer() {
//   //   return StreamTransformer<RealtimePlayingInfos, Track>.fromHandlers(
//   //       handleData: (RealtimePlayingInfos data, EventSink<Track> sink) {
//   //     Metas metas = data.current.audio.audio.metas;
//   //     Track track = Track(
//   //       id: metas.id,
//   //       artist: metas.artist,
//   //       artWork: metas.image.path,
//   //       duration: data.duration.inMilliseconds.toString(),
//   //       filePath: data.current.audio.audio.path,
//   //       size: data.
//   //     );
//   //   });
//   // }
}
