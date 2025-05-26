import 'dart:async';
import 'dart:convert';

import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/systemparameterinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/webappinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/webpageinfo_appdto.dart';
import 'package:mtracersdkexample/driver/stringassets_driver.dart';
import 'package:mtracersdkexample/driverinterface/stringassets_driverinterface.dart';
import 'package:mtracersdkexample/entity/cloudendpointdata_entity.dart';
import 'package:mtracersdkexample/entity/systemparameterdata_entity.dart';
import 'package:mtracersdkexample/entity/webappdata_entity.dart';
import 'package:mtracersdkexample/entity/webpagedata_entity.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';

class ParameterGateway implements ParameterGatewayInterface {
  late StringAssetsDriverInterface stringAssetsDriver;

  ParameterGateway() {
    stringAssetsDriver = StringAssetsDriver();
  }

  @override
  Future<SystemParameterInfoAppDto> readSystemParameterInfo() {
    final completer = Completer<SystemParameterInfoAppDto>();

    stringAssetsDriver.read("assets/platform/platform.json").then((final String params) {
      final rawEntity = json.decode(params);

      if (rawEntity["systemParameterInfo"] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final entity = SystemParameterDataEntity.fromMap(rawEntity["systemParameterInfo"]);

        final dto = SystemParameterInfoAppDto();
        dto.decryptSICKey = entity.decryptSICKey;
        dto.decryptSICIv = entity.decryptSICIv;
        dto.decryptCBCKey = entity.decryptCBCKey;
        dto.decryptCBCIv = entity.decryptCBCIv;

        completer.complete(dto);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<CloudEndpointInfoAppDto> readCloudEndpointInfo() {
    final completer = Completer<CloudEndpointInfoAppDto>();

    stringAssetsDriver.read("assets/platform/platform.json").then((final String params) {
      final rawEntity = json.decode(params);

      if (rawEntity["cloudEndpointInfo"] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final entity = CloudEndpointDataEntity.fromMap(rawEntity["cloudEndpointInfo"]);

        final dto = CloudEndpointInfoAppDto();
        dto.cloudAuthEndpointInfo.identityPoolId = entity.cloudAuthEndpointData.identityPoolId;
        dto.cloudAuthEndpointInfo.userPoolId = entity.cloudAuthEndpointData.userPoolId;
        dto.cloudAuthEndpointInfo.userPoolClientId = entity.cloudAuthEndpointData.userPoolClientId;
        dto.cloudAuthEndpointInfo.oAuthDomain = entity.cloudAuthEndpointData.oAuthDomain;
        dto.cloudAuthEndpointInfo.oAuthRedirectSignIn = entity.cloudAuthEndpointData.oAuthRedirectSignIn;
        dto.cloudAuthEndpointInfo.oAuthCallbackUrlScheme = entity.cloudAuthEndpointData.oAuthCallbackUrlScheme;
        dto.cloudAPIEndpointInfo.graphQlEndpoint = entity.cloudAPIEndpointData.graphQlEndpoint;
        dto.cloudStorageEndpointInfo.s3Region = entity.cloudStorageEndpointData.s3Region;
        dto.cloudStorageEndpointInfo.s3EndPoint = entity.cloudStorageEndpointData.s3EndPoint;
        dto.cloudStorageEndpointInfo.s3Host = entity.cloudStorageEndpointData.s3Host;
        dto.cloudStorageEndpointInfo.s3Bucket = entity.cloudStorageEndpointData.s3Bucket;

        completer.complete(dto);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<WebAppInfoAppDto> readWebAppInfo() {
    final completer = Completer<WebAppInfoAppDto>();

    stringAssetsDriver.read("assets/platform/platform.json").then((final String params) {
      final rawEntity = json.decode(params);

      if (rawEntity["webAppInfo"] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final entity = WebAppDataEntity.fromMap(rawEntity["webAppInfo"]);

        final dto = WebAppInfoAppDto();
        dto.academyUrl = entity.academyUrl;
        dto.howToUseUrl = entity.howToUseUrl;
        dto.privacyStatementUrl = entity.privacyStatementUrl;
        dto.termsOfServiceUrl = entity.termsOfServiceUrl;
        dto.webAppUrl = entity.webAppUrl;

        completer.complete(dto);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<WebPageInfoAppDto> readWebPageInfo() {
    final completer = Completer<WebPageInfoAppDto>();

    stringAssetsDriver.read("assets/platform/platform.json").then((final String params) {
      final rawEntity = json.decode(params);

      if (rawEntity["webPageInfo"] == null) {
        completer.completeError("ERR.PARAMS.NOTFOUND");
      } else {
        final entity = WebPageDataEntity.fromMap(rawEntity["webPageInfo"]);

        final dto = WebPageInfoAppDto();
        dto.authKey = entity.authKey;
        dto.reportDetailUrl = entity.reportDetailUrl;
        dto.userLessonUrl = entity.userLessonUrl;
        dto.basicLessonUrl = entity.basicLessonUrl;

        completer.complete(dto);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
