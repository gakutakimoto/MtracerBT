import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/newsinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/newsinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/news_serviceinterface.dart';

@deprecated
class NewsService extends NewsServiceInterface {
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(List<NewsInfoAppDto>), List<NewsInfoAppDto>> newsInfosDataStore;

  NewsService() {
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    newsInfosDataStore = NewsInfoDatastore();
  }

  @override
  Future<void> requestNewsInfo() {
    final completer = Completer<void>();

    late final String idToken;
    late final String accessToken;
    late final String userSub;
    late final graphQlEndNews = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
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

      return cloudAPIGateway.getNews(graphQlEndNews, accessToken, userInfo.userId);
    }).then((final List<NewsInfoAppDto>? newsInfos) {
      if (newsInfos == null || newsInfos == []) {
        newsInfosDataStore.publish([]);
        completer.complete(null);
        return;
      }
      newsInfosDataStore.publish(newsInfos);
      completer.complete();
    });

    return completer.future;
  }
}
