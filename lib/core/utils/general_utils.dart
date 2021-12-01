// import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';

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

  // static List<MediaItem> trackToMediaItem(List<Track> list) {
  //   return list
  //       .map((e) => MediaItem(id: e.id!, album: e.album!, title: e.title!))
  //       .toList();
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
