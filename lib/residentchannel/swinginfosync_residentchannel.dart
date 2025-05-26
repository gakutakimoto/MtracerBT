import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:lzstring/lzstring.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/registerswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gateway/mtracer_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logic/swing_logic.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/swing_logicinterface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:uuid/uuid.dart';

class SwingInfoSyncResidentChannel implements ChannelControlResidentChannelInterface {
  static final SwingInfoSyncResidentChannel _instance = SwingInfoSyncResidentChannel._internal();
  factory SwingInfoSyncResidentChannel() => _instance;

  late MTracerGatewayInterface mtracerGateway;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;
  late SwingLogicInterface swingLogic;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  SwingInfoSyncResidentChannel._internal() {
    mtracerGateway = MTracerGateway();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();
    localPersistenceGateway = LocalPersistenceGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();
    swingLogic = SwingLogic();

    //Datastore
    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    appStateInfoDatastore = AppStateInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
  }

  @override
  Future<void> start({Map<String, dynamic>? args}) {
    final completer = Completer<void>();

    if (args == null || !args.containsKey("path")) {
      completer.completeError(Error());
    } else {
      _start(args["path"]).then((_) {
        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      });
    }

    return completer.future;
  }

  @override
  void stop() {}

  Future<void> _start(final String path) {
    final completer = Completer<void>();

    final file = File(path);
    if (!file.existsSync()) {
      completer.completeError(Error());
    } else {
      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
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

        final idToken = _session.getIdToken().getJwtToken() ?? "";
        accessToken = _session.getAccessToken().getJwtToken() ?? "";

        if (idToken.isEmpty || accessToken.isEmpty) {
          return Future.value(null);
        }

        final encryptValue = file.readAsStringSync();
        return _genParam(encryptValue);
      }).then((final RegisterSwingInputAppDto? registerSwingInput) {
        if (registerSwingInput == null) {
          return Future.value(null);
        } else {
          return cloudAPIGateway.registerSwing(graphQlEndpoint, accessToken, registerSwingInput);
        }
      }).then((final SwingInfoAppDto? swingInfo) {
        if (swingInfo == null) {
          completer.completeError(Error());
        } else {
          log("upload");
          completer.complete();
        }
      }).catchError((error) {
        completer.completeError(error);
      });
    }

    return completer.future;
  }

  Future<RegisterSwingInputAppDto?> _genParam(final String encryptValue) async {
    //暗号化データから計測情報の一部を抽出する
    final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
    final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
    final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
    final decryptValue = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
    final swingInfo = swingLogic.convertFromJson(decryptValue);

    final dto = RegisterSwingInputAppDto();
    dto.swingId = const Uuid().v5(Uuid.NAMESPACE_OID, swingInfo.swingHeaderInfo.swingInfoId);
    dto.userId = swingInfo.swingHeaderInfo.userId;
    dto.isExistVideo = 0;
    dto.isFavorite = 0;
    dto.memo = "";

    //tbd
    dto.swingInfoId = swingInfo.swingHeaderInfo.swingInfoId;
    dto.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(swingInfo.swingHeaderInfo.swingDate);
    dto.golfClubSubId = swingInfo.swingHeaderInfo.clubId;
    dto.impactHeadSpeed = swingInfo.swingMeasurementInfo.impactHeadSpeed;
    dto.estimateCarry = swingInfo.swingMeasurementInfo.estimateCarry;
    dto.impactAttackAngle = swingInfo.swingMeasurementInfo.impactAttackAngle;
    dto.impactAttackAngleType = swingInfo.swingMeasurementInfo.impactAttackAngleType;
    dto.impactClubPath = swingInfo.swingMeasurementInfo.impactClubPath;
    dto.impactClubPathType = swingInfo.swingMeasurementInfo.impactClubPathType;
    dto.impactFaceAngle = swingInfo.swingMeasurementInfo.impactFaceAngle;
    dto.impactFaceAngleType = swingInfo.swingMeasurementInfo.impactFaceAngleType;

    //クラウドへのUpload/Download時のみ暗号化結果を圧縮する
    try {
      log(encryptValue.length.toString());
      final compressToBase64Value = LZString.compressToBase64Sync(encryptValue);
      log(compressToBase64Value!.length.toString());
      dto.rawData = compressToBase64Value;
      return dto;
    } catch (e) {
      return null;
    }
  }
}
