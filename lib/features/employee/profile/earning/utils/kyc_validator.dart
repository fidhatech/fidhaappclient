class KycValidator {
  static const String _panRegex = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  static const String _upiRegex = r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$';

  /// Validates PAN number format
  /// Returns error message if invalid, null if valid
  static String? validatePan(String? pan) {
    if (pan == null || pan.isEmpty) {
      return "PAN number is required";
    }
    final trimmedPan = pan.trim().toUpperCase();
    if (!RegExp(_panRegex).hasMatch(trimmedPan)) {
      return "Invalid PAN format (e.g. ABCDE1234F)";
    }
    return null;
  }

  /// Validates UPI ID format
  /// Returns error message if invalid, null if valid
  static String? validateUpi(String? upi) {
    if (upi == null || upi.isEmpty) {
      return "UPI ID is required";
    }
    final trimmedUpi = upi.trim();
    if (trimmedUpi.contains(' ')) {
      return "UPI ID cannot contain spaces";
    }
    if (!RegExp(_upiRegex).hasMatch(trimmedUpi)) {
      return "Invalid UPI ID format (e.g. name@bank)";
    }
    return null;
  }
}
