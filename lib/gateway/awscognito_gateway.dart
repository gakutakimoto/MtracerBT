import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/oauthinfo_appdto.dart';
import 'package:mtracersdkexample/driver/awsappsync_driver.dart';
import 'package:mtracersdkexample/driver/awscognito_driver.dart';
import 'package:mtracersdkexample/driver/awscognitoapple_driver.dart';
import 'package:mtracersdkexample/driver/awscognitogoogle_driver.dart';
import 'package:mtracersdkexample/driverinterface/cloudapi_driverinterface.dart';
import 'package:mtracersdkexample/driverinterface/cloudauth_driverinterface.dart';
import 'package:mtracersdkexample/driverinterface/snsauth_driverinterface.dart';
import 'package:mtracersdkexample/entity/oauthdata_entity.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';

class AWSCognitoGateway extends CloudAuthGatewayInterface {
  late CloudAuthDriverInterface authDriver;
  late CloudAPIDriverInterface cloudAPIDriver;
  late SNSAuthDriverInterface snsGoogleAuthDriver;
  late SNSAuthDriverInterface snsAppleAuthDriver;

  AWSCognitoGateway() {
    authDriver = AWSCognitoDriver();
    cloudAPIDriver = AWSAppSyncDriver();
    snsGoogleAuthDriver = AWSCognitoGoogleDriver();
    snsAppleAuthDriver = AWSCognitoAppleDriver();
  }

  @override
  void configure(final String userPoolId, final String userPoolClientId, final String identityPoolId) {
    authDriver.configure(userPoolId, userPoolClientId, identityPoolId);
  }

  @override
  Future<CognitoUser?> getCurrentUser() {
    final completer = Completer<CognitoUser?>();

    authDriver.getCurrentUser().then((final CognitoUser? cognitoUser) {
      completer.complete(cognitoUser);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<CognitoUserSession?> getSession(final CognitoUser cognitoUser) {
    final completer = Completer<CognitoUserSession?>();

    authDriver.getSession(cognitoUser).then((final CognitoUserSession? cognitoUserSession) {
      completer.complete(cognitoUserSession);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<CognitoUserSession?> signIn(final String userId, final String password) {
    final completer = Completer<CognitoUserSession?>();

    authDriver.signIn(userId, password).then((final CognitoUserSession? session) {
      completer.complete(session);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> signOut(final CognitoUser cognitoUser) {
    final completer = Completer<void>();

    authDriver.signOut(cognitoUser).then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  String? getUsername(final String idToken) {
    return authDriver.getUsername(idToken);
  }

  @override
  String? getUserSub(final String idToken) {
    return authDriver.getUserSub(idToken);
  }

  @override
  Future<CognitoCredentials?> getCredentials(final String identityPoolId, final String idToken) {
    final completer = Completer<CognitoCredentials?>();

    authDriver.getCredentials(identityPoolId, idToken).then((final CognitoCredentials? credentials) {
      completer.complete(credentials);
    }).catchError((error) {
      completer.complete(null);
    });

    return completer.future;
  }

  @override
  Future<bool> cacheTokens(final String userName, final String idToken, final String accessToken, final String refreshToken) {
    return authDriver.cacheTokens(userName, idToken, accessToken, refreshToken);
  }

  @override
  OAuthInfoAppDto getGoogleOAuthUrl(final String oAuthDomain, final String userPoolClientId, final String oAuthRedirectSignIn, final String oAuthCallbackUrlScheme) {
    final entity = snsGoogleAuthDriver.getOAuthUrl(oAuthDomain, userPoolClientId, oAuthRedirectSignIn, oAuthCallbackUrlScheme);

    var dto = OAuthInfoAppDto();
    dto.url = entity.url;
    dto.callbackUrlScheme = entity.callbackUrlScheme;

    return dto;
  }

  @override
  Future<OAuthInfoAppDto> signUpWithGoogle(final String uri, final String authority, final String clientId, final String redirectUri) {
    final completer = Completer<OAuthInfoAppDto>();

    snsGoogleAuthDriver.signUp(uri, authority, clientId, redirectUri).then((final OAuthDataEntity entity) {
      var dto = OAuthInfoAppDto();

      dto.refreshToken = entity.refreshToken;
      dto.idToken = entity.idToken;
      dto.accessToken = entity.accessToken;

      completer.complete(dto);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  OAuthInfoAppDto getAppleOAuthUrl(final String oAuthDomain, final String userPoolClientId, final String oAuthRedirectSignIn, final String oAuthCallbackUrlScheme) {
    final entity = snsAppleAuthDriver.getOAuthUrl(oAuthDomain, userPoolClientId, oAuthRedirectSignIn, oAuthCallbackUrlScheme);

    var dto = OAuthInfoAppDto();
    dto.url = entity.url;
    dto.callbackUrlScheme = entity.callbackUrlScheme;

    return dto;
  }

  @override
  Future<OAuthInfoAppDto> signUpWithApple(final String uri, final String authority, final String clientId, final String redirectUri) {
    final completer = Completer<OAuthInfoAppDto>();

    snsAppleAuthDriver.signUp(uri, authority, clientId, redirectUri).then((final OAuthDataEntity entity) {
      var dto = OAuthInfoAppDto();

      dto.refreshToken = entity.refreshToken;
      dto.idToken = entity.idToken;
      dto.accessToken = entity.accessToken;

      completer.complete(dto);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
