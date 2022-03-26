import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class FavoritesModel extends BaseModel {
  final _music = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();

  void onTrackTap(Track track, [String? id]) async {
    //TODO
    await _playerService.changeCurrentListOfSongs(id);
    _navigationService.toNamed(Routes.playingRoute, arguments: PlayingData(track));
  }

  void onSearchTap() =>
      _navigationService.toNamed(Routes.searchRoute, arguments: Track);

  Stream<List<Track>> streamFavorites() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield _music.favorites;
    }
  }

  void navigateBack() => _navigationService.back();

  void removeAllFavourites() {
    _music.clearFavorites();
    _navigationService.back();
  }

  List<Track> get favorites => _music.favorites;
}
