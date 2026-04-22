import 'dart:io';
import 'dart:ui';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/models/app_update_config_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showAppUpdateDialog({
  required BuildContext context,
  required AppUpdateConfig updateConfig,
}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: !updateConfig.isForceUpdate,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (context) {
      final theme = Theme.of(context);

      return WillPopScope(
        onWillPop: () async => !updateConfig.isForceUpdate,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColor.secondary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.textFieldBorder.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColor.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.system_update,
                        color: AppColor.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'App Update Available',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColor.primaryText,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Message
                    Text(
                      updateConfig.updateMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColor.secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Version info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Current: ${updateConfig.minimumVersion}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColor.secondaryText.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'New: ${updateConfig.currentVersion}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Buttons
                    if (!updateConfig.isForceUpdate)
                      Row(
                        children: [
                          // Skip Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(
                                  color: AppColor.secondaryText.withValues(alpha: 0.5),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Later',
                                style: TextStyle(
                                  color: AppColor.secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Update Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _launchAppStore(updateConfig),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: AppColor.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Update Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      // Force Update - Only Update Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _launchAppStore(updateConfig),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Update Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _launchAppStore(AppUpdateConfig updateConfig) async {
  try {
    final String url = _getStoreUrl(updateConfig);
    
    if (url.isEmpty) {
      print('Error: No store link configured for this platform');
      return;
    }
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Error: Could not launch store URL');
    }
  } catch (e) {
    print('Error launching app store: $e');
  }
}

String _getStoreUrl(AppUpdateConfig updateConfig) {
  if (Platform.isAndroid) {
    return updateConfig.playStoreLink;
  } else if (Platform.isIOS) {
    return updateConfig.appStoreLink;
  }
  // Fallback for other platforms (web, Windows, macOS, Linux)
  return updateConfig.playStoreLink.isNotEmpty
      ? updateConfig.playStoreLink
      : updateConfig.appStoreLink;
}
