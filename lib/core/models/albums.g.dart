// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumListAdapter extends TypeAdapter<AlbumList> {
  @override
  final int typeId = 2;

  @override
  AlbumList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumList(
      numberOfAlbums: fields[0] as int,
      albums: (fields[1] as List).cast<Album>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlbumList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.numberOfAlbums)
      ..writeByte(1)
      ..write(obj.albums);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  final int typeId = 5;

  @override
  Album read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Album(
      id: fields[0] as String?,
      title: fields[1] as String?,
      artwork: fields[2] as Uint8List?,
      numberOfSongs: fields[5] as int?,
      index: fields[4] as int?,
      isPlaying: fields[6] == null ? false : fields[6] as bool,
      trackIds: (fields[7] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artwork)
      ..writeByte(4)
      ..write(obj.index)
      ..writeByte(5)
      ..write(obj.numberOfSongs)
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
      other is AlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
