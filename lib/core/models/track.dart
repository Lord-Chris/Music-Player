import 'dart:io';

import 'package:hive_flutter/adapters.dart';
part 'track.g.dart';

@HiveType(typeId: 0)
class TrackList {
  @HiveField(0)
  int numberOfTracks;
  @HiveField(1)
  List<Track> tracks;

  TrackList({required this.numberOfTracks, required this.tracks});
}

@HiveType(typeId: 3)
class Track {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? displayName;
  @HiveField(3)
  String? artist;
  @HiveField(4)
  String? album;
  @HiveField(5)
  String? artWork;
  @HiveField(6)
  String? filePath;
  @HiveField(7)
  int? duration;
  @HiveField(8)
  int? index;
  @HiveField(9)
  int? size;
  @HiveField(10, defaultValue: false)
  bool isPlaying;
  @HiveField(11, defaultValue: false)
  bool favorite;
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
    this.isPlaying = false,
    this.favorite = false,
  });

  String toTime() {
    if (duration != null) {
      int? minute = DateTime.fromMillisecondsSinceEpoch(duration!).minute;
      int? second = DateTime.fromMillisecondsSinceEpoch(duration!).second;
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
      duration: map['duration'],
      artWork: map['artWork'],
      size: map['size'],
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
