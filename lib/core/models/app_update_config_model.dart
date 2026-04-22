class AppUpdateConfig {
  final bool isEnabled;
  final String minimumVersion;
  final String currentVersion;
  final String appStoreLink;
  final String playStoreLink;
  final String updateMessage;
  final bool isForceUpdate;

  AppUpdateConfig({
    required this.isEnabled,
    required this.minimumVersion,
    required this.currentVersion,
    required this.appStoreLink,
    required this.playStoreLink,
    required this.updateMessage,
    required this.isForceUpdate,
  });

  factory AppUpdateConfig.fromJson(Map<String, dynamic> json) {
    return AppUpdateConfig(
      isEnabled: json['isEnabled'] ?? false,
      minimumVersion: json['minimumVersion'] ?? '1.0.0',
      currentVersion: json['currentVersion'] ?? '1.0.0',
      appStoreLink: json['appStoreLink'] ?? '',
      playStoreLink: json['playStoreLink'] ?? '',
      updateMessage: json['updateMessage'] ?? 'Please update the app to continue',
      isForceUpdate: json['isForceUpdate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'minimumVersion': minimumVersion,
      'currentVersion': currentVersion,
      'appStoreLink': appStoreLink,
      'playStoreLink': playStoreLink,
      'updateMessage': updateMessage,
      'isForceUpdate': isForceUpdate,
    };
  }
}
