import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_response_model.freezed.dart';
part 'verify_otp_response_model.g.dart';

@freezed
sealed class VerifyOtpResponseModel with _$VerifyOtpResponseModel {

  const factory VerifyOtpResponseModel({
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'isExistingUser') @Default(false) bool isExistingUser,
    @JsonKey(name: 'tokens') @Default(VerifyOtpResponseTokensModel()) VerifyOtpResponseTokensModel tokens,
    @JsonKey(name: 'userStage') String? userStage,
  }) = _VerifyOtpResponseModel;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseModelFromJson(json);
}

@freezed
sealed class VerifyOtpResponseTokensModel with _$VerifyOtpResponseTokensModel {

  const factory VerifyOtpResponseTokensModel({
    @JsonKey(name: 'accessToken') @Default('') String accessToken,
    @JsonKey(name: 'refreshToken') @Default('') String refreshToken,
  }) = _VerifyOtpResponseTokensModel;

  factory VerifyOtpResponseTokensModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseTokensModelFromJson(json);
}

