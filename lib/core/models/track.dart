import 'dart:io';
import 'dart:typed_data';

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
  Uint8List? artwork;
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
  bool isFavorite;
  @HiveField(12)
  String? artworkPath;
  Track({
    this.index,
    this.id,
    this.title,
    this.displayName,
    this.artist,
    this.album,
    this.duration,
    this.artwork,
    this.size,
    this.filePath,
    this.isPlaying = false,
    this.isFavorite = false,
    this.artworkPath,
  });

  // stuff(){
  //   Uri().
  // }

  String toTime() {
    if (duration != null) {
      int? minute = DateTime.fromMillisecondsSinceEpoch(duration!).minute;
      int? second = DateTime.fromMillisecondsSinceEpoch(duration!).second;
      return second < 10 ? '$minute:0$second' : '$minute:$second';
    } else {
      return '';
    }
  }

  Uint8List? getArtwork() {
    try {
      if (artwork != null) {
        RandomAccessFile file = File.fromRawPath(artwork!).openSync();
        file.closeSync();
        return artwork;
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  String? toSize() {
    if (size!.toString().length > 6) {
      return '${(size! / 1000000).floor()} MB';
    } else {
      return '${(size! / 1000).floor()} KB';
    }
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
        artwork: map['artwork'],
        size: map['size'],
        filePath: map['path'],
        artworkPath: map['artworkPath']);
  }

  Map<String, dynamic> toMap() => {
        'index': index,
        'id': id,
        'title': title,
        'displayName': displayName,
        'album': album,
        'artist': artist,
        'duration': duration,
        'artwork': artwork,
        'size': size,
        'path': filePath,
        'artworkPath': artworkPath,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Track &&
      other.id == id &&
      other.title == title &&
      other.displayName == displayName &&
      other.artist == artist &&
      other.album == album &&
      other.artwork == artwork &&
      other.filePath == filePath &&
      other.duration == duration &&
      other.index == index &&
      other.size == size &&
      other.isPlaying == isPlaying &&
      other.isFavorite == isFavorite &&
      other.artworkPath == artworkPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      displayName.hashCode ^
      artist.hashCode ^
      album.hashCode ^
      artwork.hashCode ^
      filePath.hashCode ^
      duration.hashCode ^
      index.hashCode ^
      size.hashCode ^
      isPlaying.hashCode ^
      isFavorite.hashCode ^
      artworkPath.hashCode;
  }
}
