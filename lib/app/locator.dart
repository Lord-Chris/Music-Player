import 'package:get_it/get_it.dart';
import 'package:music_player/core/utils/controls/new_controls_utils.dart';
import 'package:music_player/core/utils/music_util.dart';
import 'package:music_player/core/utils/controls/controls_util.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/views/albums/albums_model.dart';
import 'package:music_player/ui/views/artists/artists_model.dart';
import 'package:music_player/ui/views/home/home_model.dart';
import 'package:music_player/ui/views/my_drawer/my_drawer_model.dart';
import 'package:music_player/ui/views/my_list/my_list_model.dart';
import 'package:music_player/ui/views/playing/playingmodel.dart';
import 'package:music_player/ui/views/search/search_model.dart';
import 'package:music_player/ui/views/songs/songs_model.dart';
import 'package:music_player/ui/shared/theme_model.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => PlayingModel());
  locator.registerFactory(() => AlbumsModel());
  locator.registerFactory(() => ArtistsModel());
  locator.registerFactory(() => SongsModel());
  locator.registerFactory(() => MyListModel());
  locator.registerFactory(() => MusicCardModel());
  locator.registerFactory(() => MyDrawerModel());
  locator.registerFactory(() => SearchModel());
  locator.registerFactory(() => MyMusicBarModel());
  print('Setting up local storage...');
  await _setUpLocalStorage();
  print('Initializing music library...');
  _setUpMusicLibrary();
  print('Initializing audio controls...');
  await _setUpAudioControls();
  locator.registerLazySingleton<ThemeChanger>(() => ThemeChanger());
  // locator.registerLazySingleton<IMusic>(() => Music());
  // locator.registerLazySingleton<AudioControls>(() => AudioControls());
}

Future<void> _setUpLocalStorage() async {
  final storage = await SharedPrefs.getInstance();
  locator.registerLazySingleton<SharedPrefs>(() => storage);
}

Future<void> _setUpAudioControls() async {
  final controls = await NewAudioControls.getInstance();
  locator.registerLazySingleton<IAudioControls>(() => controls);
}

void _setUpMusicLibrary() {
  final _library = Music.getInstance();
  locator.registerLazySingleton<IMusic>(() => _library);
}
