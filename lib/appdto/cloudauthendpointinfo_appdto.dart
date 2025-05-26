class CloudAuthEndpointInfoAppDto {
  late String identityPoolId;
  late String userPoolId;
  late String userPoolClientId;
  late String oAuthDomain;
  late String oAuthRedirectSignIn;
  late String oAuthCallbackUrlScheme;

  CloudAuthEndpointInfoAppDto() {
    identityPoolId = "";
    userPoolId = "";
    userPoolClientId = "";
    oAuthDomain = "";
    oAuthRedirectSignIn = "";
    oAuthCallbackUrlScheme = "";
  }
}
