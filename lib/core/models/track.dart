import 'dart:convert';
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

  @override
  String toString() {
    return 'Track(id: $id, title: $title, displayName: $displayName, artist: $artist, album: $album, artwork: $artwork, filePath: $filePath, duration: $duration, index: $index, size: $size, isPlaying: $isPlaying, isFavorite: $isFavorite, artworkPath: $artworkPath)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'displayName': displayName,
      'artist': artist,
      'album': album,
      'artwork': artwork,
      'filePath': filePath,
      'duration': duration,
      'index': index,
      'size': size,
      'isPlaying': isPlaying,
      'isFavorite': isFavorite,
      'artworkPath': artworkPath,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      title: map['title'],
      displayName: map['displayName'],
      artist: map['artist'],
      album: map['album'],
      artwork: map['artwork'],
      filePath: map['filePath'],
      duration: map['duration']?.toInt(),
      index: map['index']?.toInt(),
      size: map['size']?.toInt(),
      isPlaying: map['isPlaying'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      artworkPath: map['artworkPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) => Track.fromMap(json.decode(source));
}
