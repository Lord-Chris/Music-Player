import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
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
  final _appAudioService = locator<IAppAudioService>();
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
    return await locator<IPlayerService>().play(Track.fromMap(extras!));
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
      if (_appAudioService.currentTrack != null) {
        mediaItem
            .add(GeneralUtils.trackToMediaItem(_appAudioService.currentTrack!));
      }
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          AppPlayerState.Idle: AudioProcessingState.idle,
          AppPlayerState.Finished: AudioProcessingState.completed,
          AppPlayerState.Paused: AudioProcessingState.ready,
          AppPlayerState.Playing: AudioProcessingState.loading,
        }[_appAudioService.playerState]!,
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
    _appAudioService.playerStateController.stream
        .listen((AppPlayerState event) {
      mediaItem
          .add(GeneralUtils.trackToMediaItem(_appAudioService.currentTrack!));
      final playing = _player.isPlaying;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          AppPlayerState.Idle: AudioProcessingState.idle,
          AppPlayerState.Finished: AudioProcessingState.completed,
          AppPlayerState.Paused: AudioProcessingState.ready,
          AppPlayerState.Playing: AudioProcessingState.loading,
        }[_appAudioService.playerState]!,
        playing: playing,
        captioningEnabled: true,
        queueIndex: mediaItem.value == null
            ? null
            : queue.value.indexOf(mediaItem.value!),
      ));
    });
  }
}

class BackgroundAudioSession {
  static final _appAudioService = locator<IAppAudioService>();
  static final _playerService = locator<IPlayerService>();
  static final _handler = locator<AudioHandler>();
  static late StreamSubscription<void> _noiseEventSubcription;
  static late StreamSubscription<AppPlayerState> _playerStateSubcription;
  static late StreamSubscription<AudioInterruptionEvent>
      _interruptionSubcription;

  static void handleInterruptions(AudioSession audioSession) {
    bool playInterrupted = false;
    _noiseEventSubcription = audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      _handler.play();
    });
    _playerStateSubcription =
        _appAudioService.playerStateController.stream.listen((state) {
      // playInterrupted = false;
      if (state == AppPlayerState.Playing) {
        audioSession.setActive(true);
      }
    });
    _interruptionSubcription =
        audioSession.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _playerService.setVolume(_playerService.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_appAudioService.playerState == AppPlayerState.Playing) {
              _handler.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _playerService.setVolume(_playerService.volume * 2);
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _handler.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
  }

  static dispose() {
    _interruptionSubcription.cancel();
    _noiseEventSubcription.cancel();
    _playerStateSubcription.cancel();
  }
}
