import 'package:get_it/get_it.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/audio_files/audio_files_impl.dart';
import 'package:music_player/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:music_player/core/services/local_storage_service/local_storage_service.dart';
import 'package:music_player/core/services/permission_sevice/pemission_service.dart';
import 'package:music_player/core/services/permission_sevice/permission_service_impl.dart';
import 'package:music_player/core/services/player_controls/player_controls.dart';
import 'package:music_player/core/services/player_controls/player_controls_impl.dart';
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
import 'package:music_player/ui/views/splash/splash_model.dart';
import 'package:music_player/ui/widget/music_bar.dart';
import 'package:music_player/ui/widget/music_card.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerLazySingleton<ThemeChanger>(() => ThemeChanger());
  print('Setting up local storage...');
  await _setUpKeyValueStorage();
  await _setUpLocalStorage();
  print('Initializing music library...');
  _setUpAudioFiles();
  print('Initializing audio controls...');
  await _setUpAudioPlayerControls();
  locator
      .registerLazySingleton<IPermissionService>(() => PermissionServiceImpl());

  locator.registerFactory(() => SplashModel());
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
}

Future<void> _setUpKeyValueStorage() async {
  final storage = await SharedPrefs.getInstance();
  locator.registerLazySingleton<SharedPrefs>(() => storage!);
}

Future<void> _setUpLocalStorage() async {
  final storage = LocalStorageService();
  await storage.init();
  locator.registerLazySingleton<ILocalStorageService>(() => storage);
}

Future<void> _setUpAudioPlayerControls() async {
  IPlayerControls _player = await PlayerControlImpl().initPlayer();
  locator.registerLazySingleton<IPlayerControls>(() => _player);
}

void _setUpAudioFiles() {
  // final _library = AudioFilesImpl().getInstance();
  locator.registerLazySingleton<IAudioFiles>(() => AudioFilesImpl());
}
