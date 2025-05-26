import 'dart:async';
import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/driver/component/AWSCognitoStrageDriver.dart';
import 'package:mtracersdkexample/driverinterface/cloudauth_driverinterface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AWSCognitoDriver extends CloudAuthDriverInterface {
  static final AWSCognitoDriver _instance = AWSCognitoDriver._internal();
  factory AWSCognitoDriver() => _instance;

  late CognitoUserPool _userPool;

  AWSCognitoDriver._internal() {
    _userPool = CognitoUserPool("ap-northeast-1_xxxxxxxxx", "");
  }

  @override
  void configure(final String userPoolId, final String clientId, final String identityPoolId) {
    _userPool = CognitoUserPool(userPoolId, clientId);
  }

  @override
  Future<CognitoUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storage = AWSCognitoStrageDriver(prefs);
      _userPool.storage = storage;
      return await _userPool.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CognitoUserSession?> getSession(final CognitoUser cognitoUser) async {
    try {
      //tbd
      //ここでフリーズする場合がある、もしくは時間がかかる場合がある
      log("getSession");
      log(cognitoUser.pool.getUserPoolId());
      log(cognitoUser.client!.endpoint);
      final session = await cognitoUser.getSession();
      log("session");
      log(session!.accessToken.payload.toString());
      return session;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<CognitoUserSession?> signIn(final String userId, final String password) async {
    final completer = Completer<CognitoUserSession?>();

    try {
      final cognitoUser = CognitoUser(userId, _userPool, storage: _userPool.storage);
      final authDetails = AuthenticationDetails(username: userId, password: password);
      final session = await cognitoUser.authenticateUser(authDetails);

      completer.complete(session);
    } on CognitoClientException catch (e) {
      completer.completeError(e);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  @override
  Future<void> signOut(final CognitoUser cognitoUser) async {
    final completer = Completer<void>();

//tbd
//asyncとCompleterが混在している
    try {
      await cognitoUser.signOut();
      completer.complete();
    } on CognitoClientException catch (e) {
      completer.completeError(e);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  @override
  String? getUsername(final String idToken) {
    final cognitoIdToken = CognitoIdToken(idToken);

    final token = cognitoIdToken.getJwtToken() ?? "";
    if (token.isEmpty) {
      return null;
    }

    final payload = Jwt.parseJwt(token);
    return payload.containsKey("cognito:username") ? payload["cognito:username"] : null;
  }

  @override
  String? getUserSub(final String idToken) {
    final cognitoIdToken = CognitoIdToken(idToken);

    final token = cognitoIdToken.getJwtToken() ?? "";
    if (token.isEmpty) {
      return null;
    }

    final payload = Jwt.parseJwt(token);
    return payload.containsKey("sub") ? payload["sub"] : null;
  }

  @override
  Future<CognitoCredentials?> getCredentials(final String identityPoolId, final String idToken) {
    final completer = Completer<CognitoCredentials?>();

    final credentials = CognitoCredentials(identityPoolId, _userPool);

    credentials.getAwsCredentials(idToken).then((_) {
      completer.complete(credentials);
    }).catchError((error) {
      completer.complete(null);
    });

    return completer.future;
  }

  @override
  Future<bool> cacheTokens(final String userName, final String idToken, final String accessToken, final String refreshToken) async {
    final completer = Completer<bool>();

    //todo
    //SRP違反している
    //分割する
    var session = CognitoUserSession(CognitoIdToken(idToken), CognitoAccessToken(accessToken), refreshToken: CognitoRefreshToken(refreshToken));
    if (session.isValid()) {
      final prefs = await SharedPreferences.getInstance();
      final storage = AWSCognitoStrageDriver(prefs);
      _userPool.storage = storage;

      final user = CognitoUser(userName, _userPool, storage: _userPool.storage, signInUserSession: session);
      user.cacheTokens();
      completer.complete(true);
    } else {
      completer.complete(false);
    }

    return completer.future;
  }
}
