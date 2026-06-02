import '../data/onboarding_datasource.dart';

class OnboardingRepository {

  final OnboardingDatasource onboardingDatasource;

  const OnboardingRepository(this.onboardingDatasource);

  Future<void> submitAbroadUserDetails({
    required String email,
    required String name,
    required String phone,
  }) async {
    try {
      await onboardingDatasource.submitAbroadUserDetails(
        email: email,
        name: name,
        phone: phone,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}