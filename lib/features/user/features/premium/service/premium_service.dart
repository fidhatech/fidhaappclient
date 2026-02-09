import 'package:dating_app/features/user/features/premium/model/premium_response_model.dart';

import 'package:dio/dio.dart';

class PremiumService {
  final Dio dio;
  const PremiumService(this.dio);
  Future<PremiumEmployeesResponse> fetchEmployee({
    String lan = "Malayalam",
    String limit = "20",
    String offset = "0",
  }) async {
    final response = await dio.get(
      "user/discover/prime-employees",
      queryParameters: {"language": lan, "limit": limit, "offset": offset},
    );
    return PremiumEmployeesResponse.fromJson(response.data["data"]);
  }
}
