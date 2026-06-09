import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'dio_provider.dart';
import 'rest_client.dart';

@module
abstract class RestDi {

  @preResolve
  @lazySingleton
  Future<Dio> dio(DioProvider provider) async => await provider.dio;

  @singleton
  RestClient restClient(Dio dio) => RestClient(dio);
}