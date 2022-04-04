import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';

part 'artists.g.dart';

@HiveType(typeId: 1)
class ArtistList {
  @HiveField(0)
  int numberOfArtists;

  @HiveField(1)
  List<Artist> artists;

  ArtistList({required this.numberOfArtists, required this.artists});
}

@HiveType(typeId: 4)
class Artist {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  Uint8List? artwork;
  @HiveField(3)
  int? index;
  @HiveField(4)
  int? numberOfSongs;
  @HiveField(5)
  int? numberOfAlbums;
  @HiveField(6, defaultValue: false)
  bool isPlaying;
  @HiveField(7)
  List<String?>? trackIds;

  Artist({
    this.id,
    this.name,
    this.artwork,
    this.numberOfSongs,
    this.numberOfAlbums,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artwork': artwork?.toList(),
      'index': index,
      'numberOfSongs': numberOfSongs,
      'numberOfAlbums': numberOfAlbums,
      'isPlaying': isPlaying,
      'trackIds': trackIds,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'],
      name: map['name'],
      artwork:
          map['artwork'] != null ? Uint8List.fromList(map['artwork']) : null,
      index: map['index']?.toInt(),
      numberOfSongs: map['numberOfSongs']?.toInt(),
      numberOfAlbums: map['numberOfAlbums']?.toInt(),
      isPlaying: map['isPlaying'] ?? false,
      trackIds: map['trackIds'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) => Artist.fromMap(json.decode(source));
}
