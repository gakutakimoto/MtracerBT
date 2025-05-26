import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/getuserlessoncondition_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userlessoninfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/lessoninfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/lesson_serviceinterface.dart';

class LessonService extends LessonServiceInterface {
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(UserLessonInfoAppDto), UserLessonInfoAppDto> lessonInfoDataStore;

  LessonService() {
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    lessonInfoDataStore = LessonInfoDatastore();
  }

  @override
  Future<void> requestUserLessonInfo() {
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

      final condition = GetUserLessonConditionAppDto();
      condition.userId = userInfo.userId;
      return cloudAPIGateway.getUserLesson(graphQlEndpoint, accessToken, condition);
    }).then((final UserLessonInfoAppDto? userLessonInfo) {
      if (userLessonInfo == null) {
        lessonInfoDataStore.publish(UserLessonInfoAppDto());
        completer.complete(null);
        return;
      }
      lessonInfoDataStore.publish(userLessonInfo);
      completer.complete();
    });

    return completer.future;
  }
}
