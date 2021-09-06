// class TrackList {
//   List<Track> tracks;

//   TrackList({this.tracks});

//   factory TrackList.fromJson(Map<String, dynamic> json) {
//     // print(json);
//     return TrackList(tracks: parseTrack(json['list']));
//   }

//   static List<Track> parseTrack(List list) {
//     return list?.map((track) => Track.fromMap(track))?.toList();
//   }

//   Map<String, dynamic> toJson() => {
//         'list': tracks.map((track) => track.toMap()).toList(),
//       };
// }

import 'dart:io';

class Track {
  final String? id, title, displayName, artist, album, artWork;
  final String? filePath;
  final int? duration, index, size;

  Track({
    this.index,
    this.id,
    this.title,
    this.displayName,
    this.artist,
    this.album,
    this.duration,
    this.artWork,
    this.size,
    this.filePath,
  });

  String toTime() {
    if (duration != null) {
      int? minute =
          DateTime.fromMillisecondsSinceEpoch(duration!).minute;
      int? second =
          DateTime.fromMillisecondsSinceEpoch(duration!).second;
      return second < 10 ? '$minute:0$second' : '$minute:$second';
    } else
      return '';
  }

  String? getArtWork() {
    try {
      if (artWork != null) {
        RandomAccessFile file = File(artWork!).openSync();
        file.closeSync();
        return artWork;
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  String? toSize() {
    // if (size!.length > 6)
    //   return '${(size! / 1000000).floor()} MB';
    // else
      return '${(size! / 1000).floor()} KB';
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      index: map['index'],
      id: map['id'],
      title: map['title'],
      displayName: map['displayName'],
      album: map['album'],
      artist: map['artist'],
      duration: int.parse(map['duration']),
      artWork: map['artWork'],
      size: int.parse(map['size']),
      filePath: map['path'],
    );
  }

  Map<String, dynamic> toMap() => {
        'index': index,
        'id': id,
        'title': title,
        'displayName': displayName,
        'album': album,
        'artist': artist,
        'duration': duration,
        'artWork': artWork,
        'size': size,
        'path': filePath,
      };
}
