import 'package:dating_app/features/user/features/home/repository/fillter_services.dart';

class FilterRepository {
  final FilterServices service;
  FilterRepository(this.service);

  Future<List<String>> getLanguages() async {
    return await service.getLanguages();
  }
}
