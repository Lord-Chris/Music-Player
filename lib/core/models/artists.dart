import 'dart:io';

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
  String? artwork;
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

  String? getArtWork() {
    try {
      if (artwork != null) {
        RandomAccessFile file = File('$artwork').openSync();
        file.closeSync();
        return artwork;
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  factory Artist.fromMap(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      numberOfSongs: json['numberOfSongs'],
      artwork: json['artWork'],
      numberOfAlbums: json['numberOfAlbums'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'numberOfSongs': numberOfSongs,
        'artWork': artwork,
        'numberOfAlbums': numberOfAlbums,
        'index': index,
      };
}
