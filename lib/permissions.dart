import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> _ensurePermission(final Permission permission) async {
    var status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    status = await permission.request();
    if (status.isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> ensurePermissions() async {
    return await _ensurePermission(Permission.microphone);
  }
}
