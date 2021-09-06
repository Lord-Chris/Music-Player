import 'player_controls.dart';

class PlayerControlImpl implements IPlayerControls {
  static late PlayerControlImpl _player;
  @override
  Future<IPlayerControls> initPlayer() async {
    _player = PlayerControlImpl();
    return _player;
  }

  @override
  void pause() {
    // TODO: implement pause
  }

  @override
  void play() {
    // TODO: implement play
  }

  @override
  void playNext() {
    // TODO: implement playNext
  }

  @override
  void playPrevious() {
    // TODO: implement playPrevious
  }

  @override
  void toggleRepeat() {
    // TODO: implement toggleRepeat
  }

  @override
  void toggleShuffle() {
    // TODO: implement toggleShuffle
  }
}
