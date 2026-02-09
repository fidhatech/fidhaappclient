import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final String id;
  final bool isPrime;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final int audioRatePerMin;
  final int videoRatePerMin;
  final double totalEarning;
  final double todayEarning;
  final int totalCalls;
  final String name;
  final List<String> avatar;
  final List<String> language;

  const EmployeeModel({
    required this.id,
    required this.isPrime,
    required this.isAudioEnabled,
    required this.isVideoEnabled,
    required this.audioRatePerMin,
    required this.videoRatePerMin,
    required this.totalEarning,
    required this.todayEarning,
    this.totalCalls = 0,
    this.name = '',
    this.avatar = const [],
    this.language = const [],
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final callPreference = user['callPreference'] ?? {};
    final earnings = json['earnings'] ?? {};

    return EmployeeModel(
      id: user['id'] ?? '',
      isPrime: user['isPrime'] ?? false,
      isAudioEnabled: callPreference['isAudioEnabled'] ?? false,
      isVideoEnabled: callPreference['isVideoEnabled'] ?? false,
      audioRatePerMin: (user['audioRatePerMin'] as num?)?.toInt() ?? 0,
      videoRatePerMin: (user['videoRatePerMin'] as num?)?.toInt() ?? 0,
      totalEarning: (earnings['totalEarning'] as num?)?.toDouble() ?? 0.0,
      todayEarning: (earnings['todayEarning'] as num?)?.toDouble() ?? 0.0,
      totalCalls: (json['totalCalls'] as num?)?.toInt() ?? 0,
      name: user['name'] ?? '',
      avatar:
          (user['avatar'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      language:
          (user['language'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
  EmployeeModel copyWith({
    String? id,
    bool? isPrime,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    int? audioRatePerMin,
    int? videoRatePerMin,
    double? totalEarning,
    double? todayEarning,
    int? totalCalls,
    String? name,
    List<String>? avatar,
    List<String>? language,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      isPrime: isPrime ?? this.isPrime,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      audioRatePerMin: audioRatePerMin ?? this.audioRatePerMin,
      videoRatePerMin: videoRatePerMin ?? this.videoRatePerMin,
      totalEarning: totalEarning ?? this.totalEarning,
      todayEarning: todayEarning ?? this.todayEarning,
      totalCalls: totalCalls ?? this.totalCalls,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
    id,
    isPrime,
    isAudioEnabled,
    isVideoEnabled,
    audioRatePerMin,
    videoRatePerMin,
    totalEarning,
    todayEarning,
    totalCalls,
    name,
    avatar,
    language,
  ];

  @override
  String toString() {
    return "EmployeeModel(id: $id, isPrime: $isPrime, isAudioEnabled: $isAudioEnabled, isVideoEnabled: $isVideoEnabled, audioRatePerMin: $audioRatePerMin, videoRatePerMin: $videoRatePerMin, totalEarning: $totalEarning, todayEarning: $todayEarning, totalCalls: $totalCalls, name: $name, avatar: $avatar, language: $language)";
  }
}
