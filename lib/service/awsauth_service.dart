import 'dart:async';
import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/getusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/oauthinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/validation_type.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/deviceinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gateway/mtracer_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/profile_logic.dart';
import 'package:mtracersdkexample/logicinterface/profile_logicinterface.dart';
import 'package:mtracersdkexample/serviceinterface/auth_serviceinterface.dart';

class AWSAuthService extends AuthServiceInterface {
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;
  late ProfileLogicInterface profileLogic;
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late MTracerGatewayInterface mtracerGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoInfoDatastore;
  late DatastoreInterface<void Function(DeviceInfoAppDto), DeviceInfoAppDto> deviceInfoDatastore;

  AWSAuthService() {
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();
    profileLogic = ProfileLogic();
    localPersistenceGateway = LocalPersistenceGateway();
    mtracerGateway = MTracerGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    appStateInfoInfoDatastore = AppStateInfoDatastore();
    userInfoInfoDatastore = UserInfoDatastore();
    deviceInfoDatastore = DeviceInfoDatastore();
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      log("getCurrentUser");
      final currentUser = await cloudAuthGateway.getCurrentUser();
      if (currentUser == null) {
        return false;
      }

      log("getSession");
      final session = await cloudAuthGateway.getSession(currentUser);
      if (session == null) {
        return false;
      }

      log("getJwtToken");
      final idToken = session.getIdToken().getJwtToken() ?? "";
      if (idToken.isEmpty) {
        return false;
      }

      log("getUserSub");
      final userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return false;
      }

      log("");
      return session.isValid();
    } catch (e) {
      log("catch");
      return false;
    }
  }

  @override
  ValidationType validateUserId(final String? value) {
    return profileLogic.validateUserId(value);
  }

  @override
  ValidationType validatePassword(final String? value) {
    return profileLogic.validatePassword(value);
  }

  @override
  Future<bool?> signIn(final String userId, final String password) {
    final completer = Completer<bool?>();

    final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
    late final String accessToken;
    late final String userSub;
    late final UserInfoAppDto userInfo;

    cloudAuthGateway.signIn(userId, password).then((final CognitoUserSession? session) {
      if (session == null) {
        return Future.value(null);
      } else {
        final idToken = session.getIdToken().getJwtToken() ?? "";
        accessToken = session.getAccessToken().getJwtToken() ?? "";
        if (idToken.isEmpty || accessToken.isEmpty) {
          return Future.value(null);
        }

        userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
        if (userSub.isEmpty) {
          return Future.value(null);
        }

        final condition = GetUserConditionAppDto();
        condition.userSub = userSub;
        return cloudAPIGateway.getUser(graphQlEndpoint, accessToken, condition);
      }
    }).then((final UserInfoAppDto? _userInfo) {
      if (_userInfo == null) {
        return Future.value(null);
      }

      userInfo = UserInfoAppDto();
      userInfo.userId = _userInfo.userId;
      userInfo.userStatus = _userInfo.userStatus;
      userInfo.userRoleInfos = [..._userInfo.userRoleInfos];

      return Future.value(true);
    }).then((final bool? isSignedIn) async {
      if (isSignedIn == null) {
        return Future.value(null);
      }

      if (isSignedIn) {
        final isDoneUserInfo = await localPersistenceGateway.persistUserInfo(userSub, userInfo);
        return isDoneUserInfo;
      }
    }).then((final bool? isDone) {
      completer.complete(isDone);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> signOut() async {
    try {
      final cognitoUser = await cloudAuthGateway.getCurrentUser();
      if (cognitoUser == null) {
        return;
      }

      final session = await cloudAuthGateway.getSession(cognitoUser);
      if (session == null) {
        return;
      }

      final idToken = session.getIdToken().getJwtToken() ?? "";
      if (idToken.isEmpty) {
        return;
      }

      final userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return;
      }

      await cloudAuthGateway.signOut(cognitoUser);

      userInfoInfoDatastore.publish(UserInfoAppDto());

      final userInfo = await localPersistenceGateway.readUserInfo(userSub);
      await localPersistenceGateway.removeUserInfo(userSub);

      if (userInfo != null) {
        await localPersistenceGateway.removeDeviceUUIDInfo(userInfo.userId);
        await localPersistenceGateway.removeDeviceInfo(userInfo.userId);
      }

      deviceInfoDatastore.publish(DeviceInfoAppDto());

      await mtracerGateway.disconnect();
      final appStateInfo = appStateInfoInfoDatastore.getData();
      appStateInfo.isDeviceBooking = false;
      appStateInfoInfoDatastore.publish(appStateInfo);
    } catch (e) {
      return;
    }
  }

  @override
  OAuthInfoAppDto getGoogleOAuthUrl() {
    final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();
    final oauthUrl = cloudAuthGateway.getGoogleOAuthUrl(cloudEndpointInfo.cloudAuthEndpointInfo.oAuthDomain, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolClientId, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthRedirectSignIn, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthCallbackUrlScheme);
    return oauthUrl;
  }

  @override
  Future<void> signUpWithGoogle(final String uri) {
    final completer = Completer<void>();

    final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();
    cloudAuthGateway.signUpWithGoogle(uri, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthDomain, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolClientId, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthRedirectSignIn).then((final OAuthInfoAppDto oAuthInfo) {
      final userName = cloudAuthGateway.getUsername(oAuthInfo.idToken);
      return cloudAuthGateway.cacheTokens(userName ?? "", oAuthInfo.idToken, oAuthInfo.accessToken, oAuthInfo.refreshToken);
    }).catchError((error) {
      //
      log(error.toString());
    }).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }

  @override
  OAuthInfoAppDto getAppleOAuthUrl() {
    final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();
    final oauthUrl = cloudAuthGateway.getAppleOAuthUrl(cloudEndpointInfo.cloudAuthEndpointInfo.oAuthDomain, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolClientId, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthRedirectSignIn, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthCallbackUrlScheme);
    return oauthUrl;
  }

  @override
  Future<void> signUpWithApple(final String uri) {
    final completer = Completer<void>();

    final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();
    cloudAuthGateway.signUpWithApple(uri, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthDomain, cloudEndpointInfo.cloudAuthEndpointInfo.userPoolClientId, cloudEndpointInfo.cloudAuthEndpointInfo.oAuthRedirectSignIn).then((final OAuthInfoAppDto oAuthInfo) {
      final userName = cloudAuthGateway.getUsername(oAuthInfo.idToken);
      return cloudAuthGateway.cacheTokens(userName ?? "", oAuthInfo.idToken, oAuthInfo.accessToken, oAuthInfo.refreshToken);
    }).catchError((error) {
      //
      log(error.toString());
    }).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }
}
