import 'dart:async';

import 'package:dart_either/dart_either.dart';

import '../entities/failure.dart';

abstract class BaseUsecase<T, P> {

  FutureOr<Either<Failure, T>> call(P params);
} 