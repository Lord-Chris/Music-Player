import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/models/track.dart';
import 'package:path_provider/path_provider.dart';

class GeneralUtils {
  static String formatDuration(String time) {
    int len = time.length;
    if (len == 14 && time[0] != '0')
      return time.substring(0, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] == '0')
      return time.substring(3, len - 7);
    else if (len == 14 && time[0] == '0' && time[3] != '0')
      return time.substring(2, len - 7);
    else
      return '0:00';
  }

  static AppPlayerState formatPlayerState(PlayerState state) {
    switch (state) {
      case PlayerState.STOPPED:
        return AppPlayerState.Idle;
      case PlayerState.PLAYING:
        return AppPlayerState.Playing;
      case PlayerState.PAUSED:
        return AppPlayerState.Paused;
      case PlayerState.COMPLETED:
        return AppPlayerState.Finished;
      default:
        return AppPlayerState.Idle;
    }
  }

  static Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static test(Uint8List val) {
    base64.encode(val);
  }

// data:application/octet-stream;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAIQAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAA
// AABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZ
// XNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AA
// AB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
// AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYA
// APKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwAD
// EANv/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
// AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/AABEIAMgAyAMBIgACEQEDEQH/xAAeAAABBA

  static MediaItem trackToMediaItem(Track track) {
    // print(track.artWork != null ? UriData.fromBytes(track.artWork!).uri : null);
    // print(track.artWork != null ? Uri.parse(art) : null);
    try {
      return MediaItem(
        id: track.id!,
        album: track.album!,
        title: track.title!,
        artist: track.artist,
        duration: Duration(milliseconds: track.duration!),
        artUri: track.artworkPath != null ? Uri.file(track.artworkPath!) : null,
      );
    } on Exception catch (e) {
      print(e.toString());
      throw e;
    }
  }

  static List<MediaItem> trackListToMediaItemKist(List<Track> list) {
    return list
        .map((e) => MediaItem(
              id: e.id!,
              album: e.album!,
              title: e.title!,
              artist: e.artist,
              artUri: e.artworkPath != null ? Uri.file(e.artworkPath!) : null,
            ))
        .toList();
  }

  static Future<String> makeArtworkCache(Track track, Uint8List byte) async {
    String slash = Platform.pathSeparator;
    String fileName = track.id!;
    String tempPath = (await getTemporaryDirectory()).path;

    final finalPath = tempPath + slash + "thumbs" + slash + fileName;

    // print(finalPath);

    await File(finalPath).create(recursive: true);
    await File(finalPath).writeAsBytes(byte);
    return Uri.file(finalPath).toFilePath();
  }

  // static Repeat audioServiceRepeatToRepeat(AudioServiceRepeatMode mode) {
  //   switch (mode) {
  //     case AudioServiceRepeatMode.none:
  //       return Repeat.Off;
  //     case AudioServiceRepeatMode.one:
  //       return Repeat.One;
  //     case AudioServiceRepeatMode.all:
  //       return Repeat.All;
  //     case AudioServiceRepeatMode.group:
  //       return Repeat.All;
  //   }
  // }

  //   static AudioServiceRepeatMode repeatToAudioServiceRepeat(Repeat mode) {
  //   switch (mode) {
  //     case Repeat.All:
  //       return AudioServiceRepeatMode.all;
  //     case Repeat.One:
  //       return AudioServiceRepeatMode.one;
  //     case Repeat.Off:
  //       return AudioServiceRepeatMode.none;
  //   }
  // }
}
