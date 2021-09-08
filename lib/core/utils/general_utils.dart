import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/app_player_state.dart';

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
}
