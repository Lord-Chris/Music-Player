// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_player_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPlayerStateAdapter extends TypeAdapter<AppPlayerState> {
  @override
  final int typeId = 6;

  @override
  AppPlayerState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppPlayerState.Idle;
      case 1:
        return AppPlayerState.Playing;
      case 2:
        return AppPlayerState.Paused;
      case 3:
        return AppPlayerState.Finished;
      default:
        return AppPlayerState.Idle;
    }
  }

  @override
  void write(BinaryWriter writer, AppPlayerState obj) {
    switch (obj) {
      case AppPlayerState.Idle:
        writer.writeByte(0);
        break;
      case AppPlayerState.Playing:
        writer.writeByte(1);
        break;
      case AppPlayerState.Paused:
        writer.writeByte(2);
        break;
      case AppPlayerState.Finished:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPlayerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
