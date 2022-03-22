import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SongsModel extends BaseModel {
  final _music = locator<IAudioFileService>();
  final _navigationService = locator<INavigationService>();

  List<Track> get musicList => _music.songs!;
  void onSearchTap() =>
      _navigationService.toNamed(Routes.searchRoute, arguments: Track);
}
