import 'dart:io';

class Album {
  final String? id, title, artwork;
  final int? index, numberOfSongs;

  Album({this.id, this.title, this.artwork, this.numberOfSongs, this.index});

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
