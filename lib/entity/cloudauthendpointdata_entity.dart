class CloudAuthEndpointDataEntity {
  late String identityPoolId;
  late String userPoolId;
  late String userPoolClientId;
  late String oAuthDomain;
  late String oAuthRedirectSignIn;
  late String oAuthCallbackUrlScheme;

  CloudAuthEndpointDataEntity() {
    identityPoolId = "";
    userPoolId = "";
    userPoolClientId = "";
    oAuthDomain = "";
    oAuthRedirectSignIn = "";
    oAuthCallbackUrlScheme = "";
  }

  CloudAuthEndpointDataEntity.fromMap(final Map<String, dynamic> map) {
    identityPoolId = map.containsKey("identityPoolId") ? map["identityPoolId"] : "";
    userPoolId = map.containsKey("userPoolId") ? map["userPoolId"] : "";
    userPoolClientId = map.containsKey("userPoolClientId") ? map["userPoolClientId"] : "";
    oAuthDomain = map.containsKey("oAuthDomain") ? map["oAuthDomain"] : "";
    oAuthRedirectSignIn = map.containsKey("oAuthRedirectSignIn") ? map["oAuthRedirectSignIn"] : "";
    oAuthCallbackUrlScheme = map.containsKey("oAuthCallbackUrlScheme") ? map["oAuthCallbackUrlScheme"] : "";
  }
}
