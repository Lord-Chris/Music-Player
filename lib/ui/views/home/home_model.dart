import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/utils/controls/new_controls_utils.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class HomeModel extends BaseModel {
  IPlayerControls _controls = locator<IPlayerControls>();
  SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  int _selected = 2;
  late double _end;
  // StreamSubscription<PlayerState> stateSub;
  // StreamSubscription<Playing> currentSongSub;

  bool justOpening = true;
//  _player.current.listen((event) {event.audio.audio.metas.});
  onModelReady() {
    // stateSub = _controls.stateStream.listen((event) {});
    // currentSongSub = _controls.playerCurrentSong;

    // stateSub.onData((data) async {
    //   print(data);
    //   _controls.state = data;
    //   if (data == PlayerState.stop && !justOpening) {
    //     if (_sharedPrefs.readString(REPEAT, def: 'off') == 'one') {
    //       await _controls.playAndPause();
    //     }
    //     if (_sharedPrefs.readString(REPEAT, def: 'off') == 'all') {
    //       await _controls.next();
    //     }
    //     if (_sharedPrefs.readString(REPEAT, def: 'off') == 'off' &&
    //         _controls.index != _controls.songs.length - 1) {
    //       await _controls.next();
    //     }
    //   }
    //   String id = _controls?.playerCurrentSong?.audio?.audio?.metas?.id;
    //   if (id != null) await _controls.setIndex(id);
    //   justOpening = false;
    //   notifyListeners();
    // });
    // currentSongSub.onData((data) {
    //   if (data.audio.audio.metas.title == _controls.nextSong.title) {
    //     _sharedPrefs.currentSong = _controls.nextSong;
    //   }
    // });
  }

  onModelFinished() {
    // stateSub.cancel();
    // currentSongSub.cancel();
  }

  set selected(index) {
    _selected = index;
    notifyListeners();
  }

  set end(double num) {
    _end = num;
  }

  dragFinished(int num) {
    double diff = num - _end;
    if (diff.isNegative)
      _controls.playPrevious();
    else
      _controls.playNext();
  }

  onTap(int index) {
    selected = index;
  }

  void onPlayButtonTap() async {
    // await _controls.playAndPause();
    notifyListeners();
  }

  int get selected => _selected;
  // Track get nowPlaying => _controls.nowPlaying;
}
