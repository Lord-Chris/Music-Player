// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repeat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepeatAdapter extends TypeAdapter<Repeat> {
  @override
  final int typeId = 7;

  @override
  Repeat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Repeat.All;
      case 1:
        return Repeat.One;
      case 2:
        return Repeat.Off;
      default:
        return Repeat.All;
    }
  }

  @override
  void write(BinaryWriter writer, Repeat obj) {
    switch (obj) {
      case Repeat.All:
        writer.writeByte(0);
        break;
      case Repeat.One:
        writer.writeByte(1);
        break;
      case Repeat.Off:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
