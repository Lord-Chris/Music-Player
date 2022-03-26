import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SongGroupListModel extends BaseModel {
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();

  void onTrackTap(Track track, [String? id]) async {
    //TODO
    await _playerService.changeCurrentListOfSongs(id);
    _navigationService.toNamed(Routes.playingRoute, arguments: track);
  }

  void navigateBack() => _navigationService.back();
}
