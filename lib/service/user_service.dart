import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/getusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawalreason_type.dart';
import 'package:mtracersdkexample/appdto/withdrawusercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/withdrawuserinput_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/user_serviceinterface.dart';

class UserService extends UserServiceInterface {
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  UserService() {
    localPersistenceGateway = LocalPersistenceGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
  }

  @override
  Future<UserInfoAppDto?> getUserInfo() {
    final completer = Completer<UserInfoAppDto?>();

    late final String idToken;
    late final String accessToken;
    late final String userSub;
    late final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

    cloudAuthGateway.getCurrentUser().then((final CognitoUser? cognitoUser) {
      if (cognitoUser == null) {
        return Future.value(null);
      }

      return cognitoUser.getSession();
    }).then((final CognitoUserSession? session) {
      if (session == null) {
        return Future.value(null);
      }

      idToken = session.getIdToken().getJwtToken() ?? "";
      accessToken = session.getAccessToken().getJwtToken() ?? "";
      if (idToken.isEmpty || accessToken.isEmpty) {
        userSub = "";
        return Future.value(null);
      }

      userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return Future.value(null);
      }

      final condition = GetUserConditionAppDto();
      condition.userSub = userSub;
      return cloudAPIGateway.getUser(graphQlEndpoint, accessToken, condition);
    }).then((final UserInfoAppDto? userInfo) {
      //取得に成功したらローカル情報を更新する
      if (userInfo != null) {
        localPersistenceGateway.persistUserInfo(userSub, userInfo);
      }
    }).whenComplete(() async {
      //最新情報の取得成否問わず、ローカルから情報を取得する
      if (userSub.isEmpty) {
        completer.complete(null);
        return;
      }

      final userInfo = await localPersistenceGateway.readUserInfo(userSub);
      if (userInfo == null) {
        completer.complete(null);
        return;
      }
      userInfoDatastore.publish(userInfo);

      completer.complete(userInfo);
    });

    return completer.future;
  }

  @override
  Future<void> withdrawUser(final WithdrawalReasonType reasonType, final String comment) {
    final completer = Completer<void>();

    late final String idToken;
    late final String accessToken;
    late final String userSub;
    late final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
    final userInfo = userInfoDatastore.getData();

    cloudAuthGateway.getCurrentUser().then((final CognitoUser? cognitoUser) {
      if (cognitoUser == null) {
        return Future.value(null);
      }

      return cognitoUser.getSession();
    }).then((final CognitoUserSession? session) {
      if (session == null) {
        return Future.value(null);
      }

      idToken = session.getIdToken().getJwtToken() ?? "";
      accessToken = session.getAccessToken().getJwtToken() ?? "";
      if (idToken.isEmpty || accessToken.isEmpty) {
        userSub = "";
        return Future.value(null);
      }

      userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return Future.value(null);
      }

      final condition = WithdrawUserConditionAppDto();
      condition.userId = userInfo.userId;
      final input = WithdrawUserInputAppDto();
      input.comment = comment;
      input.withdrawalReasonType = reasonType;

      return cloudAPIGateway.withdrawUser(graphQlEndpoint, accessToken, condition, input);
    }).then((final UserInfoAppDto? userInfo) {
      //取得に成功したらローカル情報を更新する
      if (userInfo != null) {
        localPersistenceGateway.persistUserInfo(userSub, userInfo);
      }
    }).whenComplete(() async {
      final userInfo = await localPersistenceGateway.readUserInfo(userSub);
      if (userInfo == null) {
        completer.completeError("error");
        return;
      }
      userInfoDatastore.publish(userInfo);

      completer.complete();
    });

    return completer.future;
  }
}
