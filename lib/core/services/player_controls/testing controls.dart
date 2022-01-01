import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/core/utils/general_utils.dart';
import 'package:musicool/ui/constants/colors.dart';
import 'package:musicool/ui/constants/pref_keys.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.example.musicool.audio',
      androidNotificationChannelName: APP_NAME,
      androidShowNotificationBadge: true,
      // androidNotificationOngoing: true,
      // androidStopForegroundOnPause: true,
      androidNotificationClickStartsActivity: true,
      notificationColor: ThemeColors.kPrimary,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler() {
    _setUpNotification();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> play([String? path]) async {
    return await locator<IPlayerControls>().play();
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    return await locator<IPlayerControls>().play(extras!['path']);
  }

  @override
  Future<void> pause() async {
    return await locator<IPlayerControls>().pause();
  }

  @override
  Future<void> skipToNext() {
    return locator<IPlayerControls>().playNext();
  }

  @override
  Future<void> skipToPrevious() {
    return locator<IPlayerControls>().playPrevious();
  }

  void _setUpNotification() {
    final _player = locator<IPlayerControls>();
    if (_player.isPlaying) {
      if (_player.getCurrentTrack() != null)
        mediaItem
            .add(GeneralUtils.trackToMediaItem(_player.getCurrentTrack()!));
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        // systemActions: const {
        //   // MediaAction.seek,
        // },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          AppPlayerState.Idle: AudioProcessingState.idle,
          AppPlayerState.Finished: AudioProcessingState.completed,
          AppPlayerState.Paused: AudioProcessingState.ready,
          AppPlayerState.Playing: AudioProcessingState.loading,
        }[_player.playerState]!,
        // playing: playing,
        captioningEnabled: true,
        queueIndex: mediaItem.value == null
            ? null
            : queue.value.indexOf(mediaItem.value!),
      ));
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    final _player = locator<IPlayerControls>();
    _player.playerStateStream.listen((AppPlayerState event) {
      mediaItem.add(GeneralUtils.trackToMediaItem(_player.getCurrentTrack()!));
      final playing = _player.isPlaying;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        // systemActions: const {
        //   // MediaAction.seek,
        // },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          AppPlayerState.Idle: AudioProcessingState.idle,
          AppPlayerState.Finished: AudioProcessingState.completed,
          AppPlayerState.Paused: AudioProcessingState.ready,
          AppPlayerState.Playing: AudioProcessingState.loading,
        }[_player.playerState]!,
        playing: playing,
        captioningEnabled: true,
        queueIndex: mediaItem.value == null
            ? null
            : queue.value.indexOf(mediaItem.value!),
      ));
    });
  }
}
