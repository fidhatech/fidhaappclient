import 'package:flutter/material.dart';

/// Returns screen height divided by the given value
double controlHeight(BuildContext context, double height) {
  return MediaQuery.of(context).size.height / height;
}

/// Returns screen width divided by the given value
double controlWidth(BuildContext context, double width) {
  return MediaQuery.of(context).size.width / width;
}

/// Returns a percentage of the screen height (0.0 to 1.0)
/// Example: screenHeightPercentage(context, 0.65) returns 65% of screen height
double screenHeightPercentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height * percentage;
}

/// Returns a percentage of the screen width (0.0 to 1.0)
/// Example: screenWidthPercentage(context, 0.5) returns 50% of screen width
double screenWidthPercentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * percentage;
}

/// Device type enumeration for responsive design
enum DeviceType { mobile, tablet, desktop }

/// Returns the device type based on screen width
/// Mobile: < 600px, Tablet: 600-900px, Desktop: > 900px
DeviceType getDeviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return DeviceType.mobile;
  } else if (width < 900) {
    return DeviceType.tablet;
  } else {
    return DeviceType.desktop;
  }
}

/// Returns true if the device is in landscape orientation
bool isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

/// Returns responsive font size based on device type and base size
/// Automatically scales up for larger devices
double getResponsiveFontSize(
  BuildContext context, {
  required double mobile,
  double? tablet,
  double? desktop,
}) {
  final deviceType = getDeviceType(context);
  switch (deviceType) {
    case DeviceType.mobile:
      return mobile;
    case DeviceType.tablet:
      return tablet ?? mobile * 1.2;
    case DeviceType.desktop:
      return desktop ?? mobile * 1.4;
  }
}

/// Returns responsive spacing based on device type and orientation
/// Landscape mode uses more compact spacing
double getResponsiveSpacing(
  BuildContext context, {
  required double mobile,
  double? tablet,
  double? desktop,
}) {
  final deviceType = getDeviceType(context);
  final landscape = isLandscape(context);

  double baseSpacing;
  switch (deviceType) {
    case DeviceType.mobile:
      baseSpacing = mobile;
      break;
    case DeviceType.tablet:
      baseSpacing = tablet ?? mobile * 1.5;
      break;
    case DeviceType.desktop:
      baseSpacing = desktop ?? mobile * 2.0;
      break;
  }

  // Reduce spacing in landscape mode
  return landscape ? baseSpacing * 0.7 : baseSpacing;
}

/// Returns responsive image height as percentage of screen height
/// Adapts based on orientation to prevent overflow
double getResponsiveImageHeight(BuildContext context) {
  final landscape = isLandscape(context);
  // Portrait: 35% of height, Landscape: 25% of height
  return screenHeightPercentage(context, landscape ? 0.25 : 0.35);
}
