import 'package:permission_handler/permission_handler.dart';

import 'i_pemission_service.dart';

class PermissionService implements IPermissionService {
  @override
  Future<bool> getStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      status = await Permission.manageExternalStorage.status;
    }
    if (status == PermissionStatus.denied) {
      status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
        status = await Permission.storage.status;
        return status == PermissionStatus.granted;
      } else {
        return status == PermissionStatus.granted;
      }
    } else {
      return true;
    }
  }
}
