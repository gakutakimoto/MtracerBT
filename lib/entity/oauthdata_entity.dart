class OAuthDataEntity {
  late String url;
  late String callbackUrlScheme;
  late String refreshToken;
  late String idToken;
  late String accessToken;

  OAuthDataEntity() {
    url = "";
    callbackUrlScheme = "";
    refreshToken = "";
    idToken = "";
    accessToken = "";
  }
}
