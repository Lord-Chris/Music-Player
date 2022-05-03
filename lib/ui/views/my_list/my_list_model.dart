import 'package:musicool/app/index.dart';
import 'package:musicool/core/mixins/_mixins.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SongGroupListModel extends BaseModel with BottomSheetMixin {
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();

  void onTrackTap(Track track, [String? id]) async {
    await _playerService.changeCurrentListOfSongs(id);
    showPlayingBottomSheet(track: track);
  }

  void navigateBack() => _navigationService.back();
}
