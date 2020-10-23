import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/view_models/base_model.dart';

import '../locator.dart';

class MyListModel extends BaseModel {
  Stream<String> musicId() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      yield controls.nowPlaying?.id;
    }
  }

  AudioControls get controls => locator<AudioControls>();
}
