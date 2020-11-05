class Album {
  final String id, title, artwork, numberOfSongs;
  final int index;

  Album({this.id, this.title, this.artwork, this.numberOfSongs, this.index});

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
