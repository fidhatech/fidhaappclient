import 'dart:developer';

import 'package:dating_app/features/user/features/call/model/call_data.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dio/dio.dart';

class ClientCallService {
  final Dio _dio;
  ClientCallService(this._dio);
  Future<CallData> initiatecall(String employeeId, CallType callType) async {
    try {
      final response = await _dio.post(
        'user/call/initiate',
        data: {'calleeId': employeeId, 'callType': callType.name},
      );
      log(response.data.toString());
      return CallData.fromJson(response.data["data"]);
    } catch (e) {
      rethrow;
    }
  }
}
