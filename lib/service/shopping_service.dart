import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/shoppinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/shoppinginfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/shopping_serviceinterface.dart';

class ShoppingService extends ShoppingServiceInterface {
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(ShoppingInfoAppDto), ShoppingInfoAppDto> shoppingInfoDatastore;

  ShoppingService() {
    localPersistenceGateway = LocalPersistenceGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    shoppingInfoDatastore = ShoppingInfoDatastore();
  }

  @override
  Future<void> getShoppingInfo() {
    final completer = Completer<void>();

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

      return cloudAPIGateway.getShopping(graphQlEndpoint, accessToken);
    }).then((final ShoppingInfoAppDto? shoppingInfo) {
      if (shoppingInfo == null) {
        completer.complete();
      } else {
        final shoppingInfoDatastoreData = shoppingInfoDatastore.getData();

        shoppingInfoDatastoreData.categorys = shoppingInfo.categorys;
        shoppingInfoDatastoreData.shopItemInfos = shoppingInfo.shopItemInfos;
        shoppingInfoDatastore.publish(shoppingInfoDatastoreData);

        completer.complete();
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
