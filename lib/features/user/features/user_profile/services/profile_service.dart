import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dioClient = DioClient.instance;

  Future<void> logout(Map<String, dynamic> body) async {
    try {
      await _dioClient.post('/user/auth/logout', data: FormData.fromMap(body));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dioClient.delete('user/profile/delete');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateProfile({
    String? name,
    String? dob,
    String? avatar,
    String? about,
  }) async {
    try {
      if (avatar != null &&
          !avatar.startsWith('http') &&
          !avatar.startsWith('assets')) {
        FormData formData = FormData.fromMap({
          if (name != null && name.isNotEmpty) 'name': name,
          if (dob != null && dob.isNotEmpty) 'dob': dob,
          'about': ?about,
          'avatar': await MultipartFile.fromFile(avatar),
        });

        await _dioClient.patch('user/profile/update', data: formData);
      } else {
        final Map<String, dynamic> body = {};
        if (name != null && name.isNotEmpty) body['name'] = name;
        if (dob != null && dob.isNotEmpty) body['dob'] = dob;
        if (about != null) body['about'] = about;
        if (avatar != null && avatar.isNotEmpty) body['avatar'] = avatar;

        await _dioClient.patch(
          'user/profile/update',
          data: body,
          options: Options(contentType: Headers.jsonContentType),
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserProfileResponse> getProfile() async {
    try {
      final response = await _dioClient.get('user/profile');
      if (response.data != null && response.data['success'] == true) {
        return UserProfileResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class UserProfileResponse {
  final String name;
  final String? dob;
  final String? avatar;
  final String? about;

  UserProfileResponse({required this.name, this.dob, this.avatar, this.about});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    String? avatarUrl;
    if (json['avatar'] is List && (json['avatar'] as List).isNotEmpty) {
      avatarUrl = (json['avatar'] as List).first.toString();
    }

    return UserProfileResponse(
      name: json['name'] ?? '',
      dob: json['dob'],
      avatar: avatarUrl,
      about: json['about'] as String?,
    );
  }
}
