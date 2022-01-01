import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
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

  static MediaItem trackToMediaItem(Track track) {
    // print(track.artWork != null ? UriData.fromBytes(track.artWork!).uri : null);
    // print(track.artWork);
    try {
      return MediaItem(
        id: track.id!,
        album: track.album!,
        title: track.title!,
        artist: track.artist,
        duration: Duration(milliseconds: track.duration!),
        artUri:
            track.artWork != null ? Uri.dataFromBytes(track.artWork!) : null,
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
              artUri: e.artWork != null ? Uri.dataFromBytes(e.artWork!) : null,
            ))
        .toList();
  }

  // static Future<String> makeArtworkCache(Track track) async {
  //   var file = File.fromRawPath(track.artWork!);
  //   String slash = Platform.pathSeparator;
  //   String fileName = track.filePath!.split(slash).last;
  //   Directory? tempDir = await getApplicationSupportDirectory();
  //   String tempPath = tempDir.path;
  //   String cachePath = file.path;
  //   UriData.fromBytes(track.artWork!).uri;
  //   tempPath + slash + "art" + slash + fileName;
  //   print(cachePath);

  //   // var file = await File(cachePath)
  //   //     .writeAsBytes(track.artWork!, mode: FileMode.write);
  //   return cachePath;
  // }

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
