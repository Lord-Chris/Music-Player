abstract class IPlayerControls {
  Future<IPlayerControls?> initPlayer();
  void play();
  void pause();
  void playNext();
  void playPrevious();
  void toggleShuffle();
  void toggleRepeat();
}
