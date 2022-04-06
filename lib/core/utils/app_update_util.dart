import 'package:in_app_update/in_app_update.dart';
import 'package:musicool/app/index.dart';

class AppUpdateUtil {
  Future<AppUpdateInfo> checkUpdate() async {
    return await InAppUpdate.checkForUpdate();
  }

  void performBackgroundUpdate() async {
    await InAppUpdate.startFlexibleUpdate();
    await InAppUpdate.completeFlexibleUpdate();
  }

  void performFullScreenUpdate() {}

  static Future<void> updateApp() async {
    try {
      if (Platform.isAndroid) {
        final _util = AppUpdateUtil();
        final _res = await _util.checkUpdate();
        if (_res.updateAvailability == UpdateAvailability.updateNotAvailable) {
          return;
        }
        if (_res.flexibleUpdateAllowed) {
          _util.performBackgroundUpdate();
        } else {
          _util.performFullScreenUpdate();
        }
      }
    } catch(e) {
      
    }
  }
}
