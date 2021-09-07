import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/core/models/track.dart';

import 'player_controls.dart';

class PlayerControlImpl implements IPlayerControls {
  static late PlayerControlImpl _playerImpl;
  AudioPlayer _player = AudioPlayer(playerId: '_player');

  @override
  Future<IPlayerControls> initPlayer() async {
    _playerImpl = PlayerControlImpl();
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> play([String? path]) async {
    if (path != null) {
      await _player.play(path, isLocal: true);
    } else {
      await _player.resume();
    }
  }

  @override
  Future<Track> playNext(int index, List<Track> list) async {
    Track nextSong =
        index == list.length ? list.elementAt(0) : list.elementAt(index + 1);
    await play(nextSong.filePath!);
    return nextSong;
  }

  @override
  Future<Track> playPrevious(int index, List<Track> list) async {
    Track songBefore =
        index == 0 ? list.elementAt(list.length) : list.elementAt(index - 1);
    await play(songBefore.filePath!);
    return songBefore;
  }

  @override
  void toggleRepeat() {
    // TODO: implement toggleRepeat
  }

  @override
  void toggleShuffle() {
    // TODO: implement toggleShuffle
  }

  @override
  Future<void> disposePlayer() async {
    // await _player.closeAudioSession();
  }

  @override
  bool get isPlaying => _player.state == PlayerState.PLAYING;

  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }
}
