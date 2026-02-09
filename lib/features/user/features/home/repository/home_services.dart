import 'package:dio/dio.dart';

class HomeServices {
  final Dio dio;
  HomeServices(this.dio);

  Future<Map<String, dynamic>> fetchHomeRaw() async {
    final response = await dio.get('user/home');

    return response.data as Map<String, dynamic>;
  }

  void editProfile(String image) async {
    await dio.put('user/profile/update', data: {});
  }
}
