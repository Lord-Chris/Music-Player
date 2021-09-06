import 'dart:io';

class Artist {
  final String? id, name, artwork, numberOfSongs, numberOfAlbums;
  final int? index;

  Artist({
    this.id,
    this.name,
    this.artwork,
    this.numberOfSongs,
    this.numberOfAlbums,
    this.index,
  });

  String? getArtWork() {
    try {
      if (artwork != null) {
        RandomAccessFile file = File('$artwork').openSync();
        file.closeSync();
        return artwork;
      }      return null;

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
