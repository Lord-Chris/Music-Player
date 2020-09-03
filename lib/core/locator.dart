import 'package:get_it/get_it.dart';
import 'package:music_player/core/viewmodels/playingmodel.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerFactory(() => PlayingProvider());
}
