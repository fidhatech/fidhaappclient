import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

/// Utility class for handling URL operations
class UrlHelper {
  UrlHelper._(); // Private constructor to prevent instantiation

  /// Launch a URL in the external browser
  ///
  /// Returns true if the URL was successfully launched, false otherwise
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('UrlHelper: Cannot launch URL: $url');
        return false;
      }
    } catch (e) {
      log('UrlHelper: Error launching URL: $e');
      return false;
    }
  }
}
