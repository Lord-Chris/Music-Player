import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/shared_prefs.dart';
import 'package:musicool/ui/views/albums/albums_model.dart';
import 'package:musicool/ui/views/artists/artists_model.dart';
import 'package:musicool/ui/views/home/home_model.dart';
import 'package:musicool/ui/views/my_list/my_list_model.dart';
import 'package:musicool/ui/views/playing/playingmodel.dart';
import 'package:musicool/ui/views/search/search_model.dart';
import 'package:musicool/ui/views/songs/songs_model.dart';
import 'package:musicool/ui/shared/theme_model.dart';
import 'package:musicool/ui/views/splash/splash_model.dart';
import 'package:musicool/ui/widget/_widgets.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  _setUpAudioFiles();
  locator.registerLazySingleton<INavigationService>(() => NavigationService());
  locator.registerLazySingleton<ThemeChanger>(() => ThemeChanger());
  log('Setting up local storage...');
  await _setUpKeyValueStorage();
  await _setUpLocalStorage();
  log('Initializing music library...');
  log('Initializing audio controls...');
  await _setUpAudioPlayerControls();
  await _setUpAudioHandler();
  locator
      .registerLazySingleton<IPermissionService>(() => PermissionService());

  locator.registerFactory(() => SplashModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => PlayingModel());
  locator.registerFactory(() => AlbumsModel());
  locator.registerFactory(() => ArtistsModel());
  locator.registerFactory(() => SongsModel());
  locator.registerFactory(() => MyListModel());
  locator.registerFactory(() => MusicCardModel());
  locator.registerFactory(() => AppDrawerModel());
  locator.registerFactory(() => SearchModel());
  locator.registerFactory(() => MusicBarModel());
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
  IPlayerService _player = await PlayerService().initPlayer();
  locator.registerLazySingleton<IPlayerService>(() => _player);
}

Future<void> _setUpAudioHandler() async {
  final _handler = await initAudioService();
  locator.registerSingleton<AudioHandler>(_handler);
}

void _setUpAudioFiles() {
  locator.registerLazySingleton<IAudioFileService>(() => AudioFileService());
}
