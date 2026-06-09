import 'dart:async';

import 'package:dart_either/dart_either.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/firebase_notification_service.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../shared/domain/entities/failure.dart';
import '../../../../shared/domain/usecases/base_usecase.dart';
import '../entities/verify_otp_response.dart';
import '../repositories/authentication_repository.dart';

typedef VerifyOtpParams = ({
  String phone,
  String otp
});

final class VerifyOtp implements BaseUsecase<VerifyOtpResponse, VerifyOtpParams> {

  final AuthenticationRepository _authenticationRepository;
  final SecureStorage _secureStorage;
  final FirebaseNotificationService _notificationService;

  VerifyOtp() : 
    _authenticationRepository = getIt.get<AuthenticationRepository>(),
    _secureStorage = getIt.get<SecureStorage>(),
    _notificationService = getIt.get<FirebaseNotificationService>();

  @override
  FutureOr<Either<Failure<dynamic>, VerifyOtpResponse>> call(VerifyOtpParams params) async {
    try {
      final res = await _authenticationRepository.verifyOtp(params.phone, params.otp);

      await _secureStorage.saveTokens(
        accessToken: res.accessToken,
        refreshToken: res.refreshToken,
      );
      await _notificationService.registerTokenWithBackend();

      return Right(res);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

}