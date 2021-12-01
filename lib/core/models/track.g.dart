// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackListAdapter extends TypeAdapter<TrackList> {
  @override
  final int typeId = 0;

  @override
  TrackList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackList(
      numberOfTracks: fields[0] as int,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, TrackList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.numberOfTracks)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final int typeId = 3;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      index: fields[8] as int?,
      id: fields[0] as String?,
      title: fields[1] as String?,
      displayName: fields[2] as String?,
      artist: fields[3] as String?,
      album: fields[4] as String?,
      duration: fields[7] as int?,
      artWork: fields[5] as String?,
      size: fields[9] as int?,
      filePath: fields[6] as String?,
      isPlaying: fields[10] == null ? false : fields[10] as bool,
      favorite: fields[11] == null ? false : fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.artist)
      ..writeByte(4)
      ..write(obj.album)
      ..writeByte(5)
      ..write(obj.artWork)
      ..writeByte(6)
      ..write(obj.filePath)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.index)
      ..writeByte(9)
      ..write(obj.size)
      ..writeByte(10)
      ..write(obj.isPlaying)
      ..writeByte(11)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
