import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dating_app/core/utils/permission_helper.dart';
import 'package:dating_app/core/widgets/permission_alert.dart';

class CallPermissionService {
  static bool _isRequesting = false;

  static Future<bool> requestCallPermissions(BuildContext context) async {
    if (_isRequesting) {
      log('CallPermissionService: Request already in progress, skipping');
      // Return true if already granted, false otherwise (without triggering a new request)
      return PermissionHelper.checkPermissions([
        Permission.camera,
        Permission.microphone,
      ]);
    }

    _isRequesting = true;
    try {
      final permissions = [Permission.camera, Permission.microphone];

      // First check if already granted to avoid unnecessary popups
      if (await PermissionHelper.checkPermissions(permissions)) {
        return true;
      }

      // Request permissions
      bool granted = await PermissionHelper.requestPermissions(permissions);

      if (granted) {
        return true;
      } else {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => const PermissionAlert(
              content:
                  'Camera and Microphone permissions are required to start a call. Please allow them in settings.',
            ),
          );
        }
        return false;
      }
    } finally {
      _isRequesting = false;
    }
  }
}
