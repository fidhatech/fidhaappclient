import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final String empId;
  final String name;
  final int age;
  final String? avatar;
  final bool? isPrime;
  final List<String>? profileImages;
  final List<String> interests;
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final int? audioCallRate;
  final int? videoCallRate;
  final String? status;
  final List<String>? language;
  final String? about;

  const EmployeeModel({
    required this.empId,
    required this.name,
    required this.age,
    required this.avatar,
    required this.isPrime,
    this.profileImages,
    required this.interests,
    required this.isAudioEnabled,
    required this.isVideoEnabled,
    required this.audioCallRate,
    required this.videoCallRate,
    this.status,
    this.language,
    this.about,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    List<String>? parseStringList(dynamic value) {
      if (value is List) {
        final parsed = value
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
        return parsed.isEmpty ? null : parsed;
      }

      if (value is String && value.isNotEmpty) {
        return [value];
      }

      return null;
    }

    String? parseAvatar(dynamic value) {
      if (value is String && value.isNotEmpty) return value;
      if (value is List && value.isNotEmpty) {
        final first = value.first?.toString() ?? '';
        return first.isEmpty ? null : first;
      }
      return null;
    }

    final rawName = (json['name'] ?? '').toString().trim();
    final safeName = rawName.isEmpty ? 'Unknown User' : rawName;

    return EmployeeModel(
      empId: json['empId'] ?? json['_id'] ?? '',
      name: safeName,
      age: json['age'] ?? 0,
      isPrime: json["isPrime"],
      profileImages:
          parseStringList(json["profileImages"]) ??
          parseStringList(json["profile_image"]),
      interests: json["interest"] != null
          ? List<String>.from(json["interest"])
          : json["interests"] != null
          ? List<String>.from(json["interests"])
          : [],
      avatar: parseAvatar(json["avatar"]),
      isAudioEnabled: json['callPreference']?['isAudioEnabled'] ?? false,
      isVideoEnabled: json['callPreference']?['isVideoEnabled'] ?? false,
      audioCallRate: json['callRate']?['audioCallRate'],
      videoCallRate: json['callRate']?['videoCallRate'],
      language: json["language"] != null
          ? List<String>.from(json["language"])
          : json["languages"] != null
          ? List<String>.from(json["languages"])
          : null,
      status: json["status"],
      about: json["about"],
    );
  }

  EmployeeModel copyWith({
    String? empId,
    String? name,
    int? age,
    String? avatar,
    bool? isPrime,
    List<String>? profileImages,
    List<String>? interests,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    int? audioCallRate,
    int? videoCallRate,
    String? status,
  }) {
    return EmployeeModel(
      empId: empId ?? this.empId,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      isPrime: isPrime ?? this.isPrime,
      profileImages: profileImages ?? this.profileImages,
      interests: interests ?? this.interests,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      audioCallRate: audioCallRate ?? this.audioCallRate,
      videoCallRate: videoCallRate ?? this.videoCallRate,
      status: status ?? this.status,
      language: language ?? this.language,
      about: about ?? this.about,
    );
  }

  bool get isPremium => isPrime ?? false;

  @override
  List<Object?> get props => [
    empId,
    name,
    age,
    avatar,
    isPrime,
    profileImages,
    interests,
    isAudioEnabled,
    isVideoEnabled,
    audioCallRate,
    videoCallRate,
    status,
  ];
}
