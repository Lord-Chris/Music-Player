import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/ui/views/base_view/base_model.dart';

class SongsModel extends BaseModel {
  IAudioFiles _music = locator<IAudioFiles>();

  List<Track> get musicList => _music.songs!;
  // locator<ILocalStorageService>()
  //     .getFromBox(MUSICLIST, def: []).cast<Track>();
}
