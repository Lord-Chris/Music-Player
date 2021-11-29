import 'dart:async';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class HomeModel extends BaseModel {
  IPlayerControls _controls = locator<IPlayerControls>();
  IAudioFiles _music = locator<IAudioFiles>();
  late StreamSubscription<AppPlayerState> stateSub;
  AppPlayerState _playerState = AppPlayerState.Idle;
  bool _isOpening = true;
  // StreamSubscription<Playing> currentSongSub;

  bool justOpening = true;
  onModelReady() {
    stateSub = _streamState().listen((data) async {
      List<Track> list;
      if (data != _playerState) {
        list = _music.currentSongs.isEmpty ? _music.songs : _music.currentSongs;

        print('APPSTATE STREAM VALUE: $data');
        // if (data == AppPlayerState.Finished) {
        //   if (_controls.repeatState == Repeat.One) {
        //     await _controls.play();
        //   } else if (_controls.repeatState == Repeat.All) {
        //     await _controls.playNext(nowPlaying.index!, list);
        //   } else if (_controls.repeatState == Repeat.Off &&
        //       nowPlaying?.index! != list.length - 1) {
        //     await _controls.playNext(nowPlaying.index!, list);
        //   }
        // }
        _playerState = data;
        notifyListeners();
      }
      // print(_playerState);
      if (_isOpening && _playerState == AppPlayerState.Idle) {
        _playerState = data;
        notifyListeners();
        _isOpening = false;
      }

      // String? id = _controls.getCurrentTrack().id;
      // if (id != null) await _controls.setIndex(id);
      // justOpening = false;
    });
    // currentSongSub = _controls.playerCurrentSong;

    // stateSub.onData((data) async {
    //   AppPlayerState state = _controls.playerState;
    //   if (data != state) {
    //     print('APPSTATE STREAM VALUE: $data');
    //     if (data == AppPlayerState.Finished) {
    //       if (_controls.repeatState == Repeat.One) {
    //         await _controls.play();
    //       } else if (_controls.repeatState == Repeat.All) {
    //         await _controls.playNext(
    //             _controls.getCurrentTrack().index!, _music.songs);
    //       } else if (_controls.repeatState == Repeat.Off &&
    //           _controls.getCurrentTrack().index! != _music.songs.length - 1) {
    //         await _controls.playNext(
    //             _controls.getCurrentTrack().index!, _music.songs);
    //       }
    //     }
    //   }
    //   // String? id = _controls.getCurrentTrack().id;
    //   // if (id != null) await _controls.setIndex(id);
    //   // justOpening = false;
    //   // notifyListeners();
    // });
    // currentSongSub.onData((data) {
    //   if (data.audio.audio.metas.title == _controls.nextSong.title) {
    //     _sharedPrefs.currentSong = _controls.nextSong;
    //   }
    // });
  }

  onModelFinished() {
    _controls.disposePlayer();
    stateSub.cancel();
    AudioService.disconnect();
    print('Disconnected');
// currentSongSub.cancel();
  }

  // set selected(index) {
  //   _selected = index;
  //   notifyListeners();
  // }

  Stream<AppPlayerState> _streamState() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      yield _controls.playerState;
    }
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

  // onTap(int index) {
  //   selected = index;
  // }

  // void onPlayButtonTap() async {
  //   // await _controls.playAndPause();
  //   notifyListeners();
  // }

  // int get selected => _selected;
  Track? get nowPlaying => _controls.getCurrentTrack();
  bool get isPlaying => _controls.isPlaying;
}
