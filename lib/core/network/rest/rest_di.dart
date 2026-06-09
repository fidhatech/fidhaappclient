import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'dio_provider.dart';
import 'rest_client.dart';

@module
abstract class RestDi {

  @preResolve
  Future<Dio> get dio => DioProvider().dio;

  @singleton
  Future<RestClient> get restClient async => RestClient(await dio);
}