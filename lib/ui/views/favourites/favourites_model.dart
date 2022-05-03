import 'package:musicool/app/index.dart';
import 'package:musicool/core/mixins/_mixins.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class FavouritesModel extends BaseModel with BottomSheetMixin {
  final _music = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();

  void onTrackTap(Track track, [String? id]) async {
    await _playerService.changeCurrentListOfSongs(id);
    showPlayingBottomSheet(track: track);
  }

  void onSearchTap() =>
      _navigationService.toNamed(Routes.searchRoute, arguments: Track);

  Stream<List<Track>> streamfavourites() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield _music.favourites;
    }
  }

  void navigateBack() => _navigationService.back();

  void removeAllFavourites() {
    _music.clearFavourites();
    _navigationService.back();
  }

  List<Track> get favourites => _music.favourites;
}
