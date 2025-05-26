import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/attachswingvideocondition_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/awss3_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudstorage_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';

class SwingVideoSyncResidentChannel implements ChannelControlResidentChannelInterface {
  static final SwingVideoSyncResidentChannel _instance = SwingVideoSyncResidentChannel._internal();
  factory SwingVideoSyncResidentChannel() => _instance;

  late ParameterGatewayInterface parameterGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudStorageGatewayInterface cloudStorageGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;

  SwingVideoSyncResidentChannel._internal() {
    parameterGateway = ParameterGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudStorageGateway = AWSS3Gateway();
    cloudAPIGateway = AWSAppSyncGateway();

    //Datastore
    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    appStateInfoDatastore = AppStateInfoDatastore();
  }

  @override
  Future<void> start({Map<String, dynamic>? args}) {
    final completer = Completer<void>();

    if (args == null || !args.containsKey("userId") || !args.containsKey("swingDate") || !args.containsKey("path") || !args.containsKey("swingInfoId")) {
      completer.completeError(Error());
    } else {
      _start(args["userId"], args["swingDate"], args["path"], args["swingInfoId"]).then((_) {
        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      });
    }

    return completer.future;
  }

  @override
  void stop() {}

  Future<void> _start(final String userId, final String swingDate, final String path, final String swingInfoId) {
    final completer = Completer<void>();

    final file = File(path);
    if (!file.existsSync()) {
      completer.completeError(Error());
    } else {
      late final String accessToken;
      late final CognitoCredentials credentials;

      cloudAuthGateway.getCurrentUser().then((final CognitoUser? currentUser) {
        if (currentUser == null) {
          return Future.value(null);
        }

        return cloudAuthGateway.getSession(currentUser);
      }).then((final CognitoUserSession? _session) {
        if (_session == null) {
          return Future.value(null);
        }

        final idToken = _session.getIdToken().getJwtToken() ?? "";
        if (idToken.isEmpty) {
          return Future.value(null);
        }

        accessToken = _session.getAccessToken().getJwtToken() ?? "";
        if (accessToken.isEmpty) {
          return Future.value(null);
        }

        final identityPoolId = cloudEndpointInfoDatastore.getData().cloudAuthEndpointInfo.identityPoolId;
        return cloudAuthGateway.getCredentials(identityPoolId, idToken);
      }).then((final CognitoCredentials? _credentials) {
        if (_credentials == null) {
          return Future.value(null);
        }

        credentials = _credentials;
        final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

        final attachSwingVideoCondition = AttachSwingVideoConditionAppDto();
        attachSwingVideoCondition.swingInfoId = swingInfoId;
        return cloudAPIGateway.attachSwingVideo(graphQlEndpoint, accessToken, attachSwingVideoCondition);
      }).then((final SwingInfoAppDto? swingInfo) {
        if (swingInfo == null) {
          return Future.value(false);
          //tbd
          //rawで存在チェックする？
        } else if (swingInfo.raw.isEmpty) {
          return Future.value(false);
        } else {
          final cloudEndpointInfo = cloudEndpointInfoDatastore.getData();
          final bucketKey = "public/" + userId + "/video/" + swingDate + "/" + swingInfoId + ".mp4";

          return cloudStorageGateway.upload(
            credentials.accessKeyId!,
            credentials.sessionToken!,
            credentials.secretAccessKey!,
            cloudEndpointInfo.cloudStorageEndpointInfo.s3Region,
            cloudEndpointInfo.cloudStorageEndpointInfo.s3EndPoint,
            cloudEndpointInfo.cloudStorageEndpointInfo.s3Bucket,
            5,
            bucketKey,
            file,
          );
        }
      }).then((final bool isSuccess) {
        if (isSuccess) {
          log("file.deleteSync()");
          file.deleteSync();
        }

        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      });
    }

    return completer.future;
  }
}
