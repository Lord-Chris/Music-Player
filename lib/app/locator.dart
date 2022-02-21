import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:musicool/core/services/audio_files/audio_files.dart';
import 'package:musicool/core/services/audio_files/audio_files_impl.dart';
import 'package:musicool/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:musicool/core/services/local_storage_service/local_storage_service.dart';
import 'package:musicool/core/services/permission_sevice/pemission_service.dart';
import 'package:musicool/core/services/permission_sevice/permission_service_impl.dart';
import 'package:musicool/core/services/player_controls/player_controls.dart';
import 'package:musicool/core/services/player_controls/player_controls_impl.dart';
import 'package:musicool/core/services/player_controls/testing_controls.dart';
import 'package:musicool/core/utils/shared_prefs.dart';
import 'package:musicool/ui/views/albums/albums_model.dart';
import 'package:musicool/ui/views/artists/artists_model.dart';
import 'package:musicool/ui/views/home/home_model.dart';
import 'package:musicool/ui/views/my_drawer/my_drawer_model.dart';
import 'package:musicool/ui/views/my_list/my_list_model.dart';
import 'package:musicool/ui/views/playing/playingmodel.dart';
import 'package:musicool/ui/views/search/search_model.dart';
import 'package:musicool/ui/views/songs/songs_model.dart';
import 'package:musicool/ui/shared/theme_model.dart';
import 'package:musicool/ui/views/splash/splash_model.dart';
import 'package:musicool/ui/widget/music_bar.dart';
import 'package:musicool/ui/widget/music_card.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  _setUpAudioFiles();
  locator.registerLazySingleton<ThemeChanger>(() => ThemeChanger());
  log('Setting up local storage...');
  await _setUpKeyValueStorage();
  await _setUpLocalStorage();
  print('Initializing music library...');
  print('Initializing audio controls...');
  await _setUpAudioPlayerControls();
  await _setUpAudioHandler();
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

Future<void> _setUpAudioHandler() async {
  final _handler = await initAudioService();
  locator.registerSingleton<AudioHandler>(_handler);
}

void _setUpAudioFiles() {
  locator.registerLazySingleton<IAudioFiles>(() => AudioFilesImpl());
}
