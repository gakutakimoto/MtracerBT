import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserpointcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userpointinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/pointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/point_serviceinterface.dart';

class PointService extends PointServiceInterface {
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(UserPointInfoAppDto), UserPointInfoAppDto> pointInfoDataStore;

  PointService() {
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    pointInfoDataStore = PointInfoDatastore();
  }

  @override
  Future<void> requestPointInfo({required final int offset}) {
    final completer = Completer<void>();

    late final String idToken;
    late final String accessToken;
    late final String userSub;
    late final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
    final userInfo = userInfoDatastore.getData();
    const limit = 10;

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

      final condition = GetUserPointConditionAppDto();
      condition.userId = userInfo.userId;
      condition.limit = limit;
      condition.offset = offset;
      return cloudAPIGateway.getUserPoint(graphQlEndpoint, accessToken, condition);
    }).then((final UserPointInfoAppDto? userPointInfo) {
      if (userPointInfo == null) {
        pointInfoDataStore.publish(UserPointInfoAppDto());
        completer.complete(null);
        return;
      }
      pointInfoDataStore.publish(userPointInfo);
      completer.complete();
    });

    return completer.future;
  }
}
