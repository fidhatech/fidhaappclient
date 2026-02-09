import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Check if all permissions are granted
    bool allGranted = statuses.values.every((status) => status.isGranted);

    return allGranted;
  }

  static Future<bool> checkPermissions(List<Permission> permissions) async {
    for (var permission in permissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }
}
