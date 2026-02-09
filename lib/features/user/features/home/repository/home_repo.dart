import 'package:dating_app/features/user/features/home/repository/home_services.dart';
import 'package:dating_app/features/user/models/user_model.dart';

class HomeRepository {
  final HomeServices service;
  HomeRepository(this.service);

  Future<UserModel> fetchHome() async {
    final raw = await service.fetchHomeRaw();

    return UserModel.fromJson(raw["user"]);
  }

  void editProfile() async {}
}
