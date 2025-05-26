import 'package:mtracersdkexample/appdto/oauthinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/validation_type.dart';

abstract class AuthServiceInterface {
  Future<bool> isSignedIn();
  ValidationType validateUserId(final String? value);
  ValidationType validatePassword(final String? value);
  Future<bool?> signIn(final String userId, final String password);
  Future<void> signOut();
  OAuthInfoAppDto getGoogleOAuthUrl();
  Future<void> signUpWithGoogle(final String uri);
  OAuthInfoAppDto getAppleOAuthUrl();
  Future<void> signUpWithApple(final String uri);
}
