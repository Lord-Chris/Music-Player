import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/app_player_state.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class HomeModel extends BaseModel {
  final _controls = locator<IPlayerControls>();
  final _handler = locator<AudioHandler>();
  late StreamSubscription<AppPlayerState> stateSub;

  bool justOpening = true;
  void onModelReady() {
    print(_controls.playerState);
    if (justOpening && _controls.playerState == AppPlayerState.Playing) {
      _controls.updatePlayerState(AppPlayerState.Playing);
      justOpening = false;
      notifyListeners();
    }
    stateSub = _controls.playerStateStream.listen((data) async {});
    stateSub.onData((data) async {
      // print("CHANGE OCCUREEDDDD");
      List<Track> list;
      if (data != _controls.playerState) {
        await _controls.updatePlayerState(data);
        list = _controls.getCurrentListOfSongs();

        if (data == AppPlayerState.Finished) {
          if (_controls.repeatState == Repeat.One) {
            await _handler.play();
          } else if (_controls.repeatState == Repeat.All) {
            await _handler.skipToNext();
          } else if (_controls.repeatState == Repeat.Off &&
              _controls.getCurrentTrack()!.index! != list.length - 1) {
            await _handler.skipToNext();
          }
        }
      }
      notifyListeners();
    });
  }

  void onModelFinished() {
    _controls.disposePlayer();
    stateSub.cancel();
    print('Disconnected');
  }

  // set end(double num) {
  //   _end = num;
  // }

  // dragFinished(int num) {
  //   double diff = num - _end;
  //   // if (diff.isNegative)
  //   //   _controls.playPrevious();
  //   // else
  //   //   _controls.playNext();
  // }

  Track? get nowPlaying => _controls.getCurrentTrack();
  bool get isPlaying => _controls.isPlaying;
}
