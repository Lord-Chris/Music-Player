import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/_constants.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => BackgroundPlayerService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.musicool.player.notification',
      androidNotificationChannelName: APP_NAME,
      androidShowNotificationBadge: true,
      androidNotificationClickStartsActivity: true,
      notificationColor: ThemeColors.kPrimary,
    ),
  );
}

class BackgroundPlayerService extends BaseAudioHandler {
  BackgroundPlayerService() {
    _setUpNotification();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  @override
  Future<void> play([String? path]) async {
    return await locator<IPlayerService>().play();
  }

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    return await locator<IPlayerService>().play(extras!['path']);
  }

  @override
  Future<void> pause() async {
    return await locator<IPlayerService>().pause();
  }

  @override
  Future<void> skipToNext() {
    return locator<IPlayerService>().playNext();
  }

  @override
  Future<void> skipToPrevious() {
    return locator<IPlayerService>().playPrevious();
  }

  void _setUpNotification() {
    final _player = locator<IPlayerService>();
    if (_player.isPlaying) {
      if (_player.getCurrentTrack() != null) {
        mediaItem
            .add(GeneralUtils.trackToMediaItem(_player.getCurrentTrack()!));
      }
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
    final _player = locator<IPlayerService>();
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
