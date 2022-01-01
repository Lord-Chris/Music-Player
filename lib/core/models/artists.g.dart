// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artists.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistListAdapter extends TypeAdapter<ArtistList> {
  @override
  final int typeId = 1;

  @override
  ArtistList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistList(
      numberOfArtists: fields[0] as int,
      artists: (fields[1] as List).cast<Artist>(),
    );
  }

  @override
  void write(BinaryWriter writer, ArtistList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.numberOfArtists)
      ..writeByte(1)
      ..write(obj.artists);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 4;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      id: fields[0] as String?,
      name: fields[1] as String?,
      artwork: fields[2] as Uint8List?,
      numberOfSongs: fields[4] as int?,
      numberOfAlbums: fields[5] as int?,
      index: fields[3] as int?,
      isPlaying: fields[6] == null ? false : fields[6] as bool,
      trackIds: (fields[7] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.artwork)
      ..writeByte(3)
      ..write(obj.index)
      ..writeByte(4)
      ..write(obj.numberOfSongs)
      ..writeByte(5)
      ..write(obj.numberOfAlbums)
      ..writeByte(6)
      ..write(obj.isPlaying)
      ..writeByte(7)
      ..write(obj.trackIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
