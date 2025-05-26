import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mtracersdkexample/driverinterface/snsauth_driverinterface.dart';
import 'package:mtracersdkexample/entity/oauthdata_entity.dart';

class AWSCognitoGoogleDriver extends SNSAuthDriverInterface {
  @override
  OAuthDataEntity getOAuthUrl(final String authority, final String clientId, final String redirectUri, final String callbackUrlScheme) {
    var oAuthInfo = OAuthDataEntity();

    oAuthInfo.url = Uri.https(
      authority,
      "/oauth2/authorize",
      {
        "client_id": clientId,
        "identity_provider": "Google",
        "response_type": "code",
        "redirect_uri": redirectUri,
        "scope": "phone openid profile aws.cognito.signin.user.admin",
      },
    ).toString();
    oAuthInfo.callbackUrlScheme = callbackUrlScheme;

    return oAuthInfo;
  }

  @override
  Future<OAuthDataEntity> signUp(final String uri, final String authority, final String clientId, final String redirectUri) {
    final completer = Completer<OAuthDataEntity>();

    var tokenEndpoint = Uri.https(authority, "/oauth2/token");
    var cognitoAuthCode = Uri.parse(uri).queryParameters["code"];

    http.post(
      tokenEndpoint,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "client_id": clientId,
        "code": cognitoAuthCode,
        "redirect_uri": redirectUri,
        "scope": "phone openid profile aws.cognito.signin.user.admin",
      },
    ).then((response) {
      var oAuthInfo = OAuthDataEntity();

      oAuthInfo.refreshToken = json.decode(response.body)["refresh_token"];
      oAuthInfo.idToken = json.decode(response.body)["id_token"];
      oAuthInfo.accessToken = json.decode(response.body)["access_token"];

      completer.complete(oAuthInfo);
    });

    return completer.future;
  }
}
