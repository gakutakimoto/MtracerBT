import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/appinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/getappcondition_appdto.dart';
import 'package:mtracersdkexample/datastore/appinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/app_serviceinterface.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppService extends AppServiceInterface {
  late CloudAPIGatewayInterface cloudAPIGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(AppInfoAppDto), AppInfoAppDto> appInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;

  AppService() {
    cloudAPIGateway = AWSAppSyncGateway();
    cloudAuthGateway = AWSCognitoGateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    appInfoDatastore = AppInfoDatastore();
    appStateInfoDatastore = AppStateInfoDatastore();
  }

  @override
  Future<bool> isAccept() {
    final completer = Completer<bool>();

    final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();

    late final String accessToken;
    cloudAuthGateway.getCurrentUser().then((final CognitoUser? currentUser) {
      if (currentUser == null) {
        return Future.value(null);
      }

      return cloudAuthGateway.getSession(currentUser);
    }).then((final CognitoUserSession? _session) {
      if (_session == null) {
        return Future.value(null);
      }

      accessToken = _session.getAccessToken().getJwtToken() ?? "";
      if (accessToken.isEmpty) {
        return Future.value(null);
      }

      return PackageInfo.fromPlatform();
    }).then((final PackageInfo? packageInfo) {
      if (packageInfo == null) {
        return Future.value(null);
      }

      final appInfo = AppInfoAppDto();
      appInfo.version = packageInfo.version;

      final condition = GetAppConditionAppDto();
      condition.version = appInfo.version;
      return cloudAPIGateway.getApp(cloudEndpointInfo.cloudAPIEndpointInfo.graphQlEndpoint, accessToken, condition);
    }).then((final AppInfoAppDto? appInfo) {
      if (appInfo == null) {
        completer.complete(false);
        return;
      }

      final data = appInfoDatastore.getData();
      data.version = appInfo.version;
      data.isAccept = appInfo.isAccept;
      appInfoDatastore.publish(data);

      completer.complete(data.isAccept);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  void startLoading() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isLoading = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  @override
  void stopLoading() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isLoading = false;
    appStateInfoDatastore.publish(appStateInfo);
  }

  @override
  void startDeviceLoading() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isDeviceLoading = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  @override
  void stopDeviceLoading() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isDeviceLoading = false;
    appStateInfoDatastore.publish(appStateInfo);
  }

  @override
  void startTraining() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isInTraining = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  @override
  void stopTraining() {
    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isInTraining = false;
    appStateInfoDatastore.publish(appStateInfo);
  }
}
