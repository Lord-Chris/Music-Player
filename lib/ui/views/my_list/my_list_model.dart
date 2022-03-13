import 'package:musicool/app/index.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class SongGroupListModel extends BaseModel {
  final _navigationService = locator<INavigationService>();

  void navigateBack() => _navigationService.back();
}
