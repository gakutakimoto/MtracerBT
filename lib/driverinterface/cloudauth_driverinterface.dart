import 'package:amazon_cognito_identity_dart_2/cognito.dart';

abstract class CloudAuthDriverInterface {
  void configure(final String userPoolId, final String clientId, final String identityPoolId);
  Future<CognitoUser?> getCurrentUser();
  Future<CognitoUserSession?> getSession(final CognitoUser cognitoUser);
  Future<CognitoUserSession?> signIn(final String userId, final String password);
  Future<void> signOut(final CognitoUser cognitoUser);
  String? getUsername(final String idToken);
  String? getUserSub(final String idToken);
  Future<CognitoCredentials?> getCredentials(final String identityPoolId, final String idToken);
  Future<bool> cacheTokens(final String userName, final String idToken, final String accessToken, final String refreshToken);
}
