import 'dart:io';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';

part 'albums.g.dart';

@HiveType(typeId: 2)
class AlbumList {
  @HiveField(0)
  int numberOfAlbums;
  @HiveField(1)
  List<Album> albums;
  AlbumList({required this.numberOfAlbums, required this.albums});
}

@HiveType(typeId: 5)
class Album {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  Uint8List? artwork;
  @HiveField(4)
  int? index;
  @HiveField(5)
  int? numberOfSongs;
  @HiveField(6, defaultValue: false)
  bool isPlaying;
  @HiveField(7)
  List<String?>? trackIds;

  Album({
    this.id,
    this.title,
    this.artwork,
    this.numberOfSongs,
    this.index,
    this.isPlaying = false,
    this.trackIds,
  });

  Uint8List? getArtWork() {
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

  factory Album.fromMap(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      numberOfSongs: json['numberOfSongs'],
      artwork: json['artWork'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'numberOfSongs': numberOfSongs,
        'artWork': artwork,
        'index': index,
      };
}
