import 'package:dating_app/di/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/services/firebase_notification_service.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../data/repositories/user_auth_repository.dart';

typedef SigninWithGoogleResult = ({
  String email,
  bool userExists,
});

class SigninWithGoogleUsecase {

  final UserAuthRepository repo;

  SigninWithGoogleUsecase() : repo = sl<UserAuthRepository>();

  Future<SigninWithGoogleResult> call() async {
    await GoogleSignIn.instance.initialize();
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    
    final authorized = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: authorized.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final res = await repo.checkUserExists(googleUser.email);

    await SecureStorage.saveTokens(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
    await FirebaseNotificationService.registerTokenWithBackend();

    return (
      email: googleUser.email,
      userExists: res.isExistingUser,
    );
  }
}