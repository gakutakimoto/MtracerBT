import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mtracersdkexample/appdto/webpageinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/webpageinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/serviceinterface/webpage_serviceinterface.dart';

class WebPageService extends WebPageServiceInterface {
  late DatastoreInterface<void Function(WebPageInfoAppDto), WebPageInfoAppDto> webPageInfoDatastore;

  late StringCodecLogicInterface stringCodecLogic;
  late ParameterGatewayInterface parameterGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;

  WebPageService() {
    webPageInfoDatastore = WebPageInfoDatastore();

    stringCodecLogic = StringCodecLogic();
    parameterGateway = ParameterGateway();
    cloudAuthGateway = AWSCognitoGateway();
  }

  @override
  Future<void> configure() async {
    final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
    final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptSICKey);
    final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptSICIv);

    final webPageInfo = await parameterGateway.readWebPageInfo();

    final authKey = stringCodecLogic.decrypt(decryptKey, decryptIv, webPageInfo.authKey);
    final reportDetailUrl = stringCodecLogic.decrypt(decryptKey, decryptIv, webPageInfo.reportDetailUrl);
    final userLessonUrl = stringCodecLogic.decrypt(decryptKey, decryptIv, webPageInfo.userLessonUrl);
    final basicLessonUrl = stringCodecLogic.decrypt(decryptKey, decryptIv, webPageInfo.basicLessonUrl);

    final data = webPageInfoDatastore.getData();
    data.authKey = authKey;
    data.reportDetailUrl = reportDetailUrl;
    data.userLessonUrl = userLessonUrl;
    data.basicLessonUrl = basicLessonUrl;
    webPageInfoDatastore.publish(data);
  }

  @override
  Future<void> getReportDetailWebPageUrl(final String customParam) {
    final completer = Completer<void>();

    late final String idToken;
    late final String refreshToken;
    late final String userSub;
    late final String generateUrl;
    final reportDetailUrl = webPageInfoDatastore.getData().reportDetailUrl;

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
      refreshToken = session.getRefreshToken()!.getToken() ?? "";
      if (idToken.isEmpty || refreshToken.isEmpty) {
        userSub = "";
        return Future.value(null);
      }

      userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return Future.value(null);
      }

      generateUrl = "$reportDetailUrl?sub=$userSub&token=$refreshToken" + customParam;
    }).whenComplete(() {
      final webPageInfo = webPageInfoDatastore.getData();
      webPageInfo.generateUrl = generateUrl;
      webPageInfoDatastore.publish(webPageInfo);

      completer.complete();
    });

    return completer.future;
  }

  @override
  Future<void> getUserLessonWebPageUrl(final String lessonId) {
    final completer = Completer<void>();

    late final String idToken;
    late final String refreshToken;
    late final String userSub;
    late final String generateUrl;
    final userLessonUrl = webPageInfoDatastore.getData().userLessonUrl;

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
      refreshToken = session.getRefreshToken()!.getToken() ?? "";
      if (idToken.isEmpty || refreshToken.isEmpty) {
        userSub = "";
        return Future.value(null);
      }

      userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return Future.value(null);
      }

      generateUrl = "$userLessonUrl?sub=$userSub&token=$refreshToken&m_lesson_id=$lessonId";
    }).whenComplete(() {
      final webPageInfo = webPageInfoDatastore.getData();
      webPageInfo.generateUrl = generateUrl;
      webPageInfoDatastore.publish(webPageInfo);

      completer.complete();
    });

    return completer.future;
  }

  @override
  Future<void> getLessonBasicWebPageUrl() {
    final completer = Completer<void>();

    late final String idToken;
    late final String refreshToken;
    late final String userSub;
    late final String generateUrl;
    final basicLessonUrl = webPageInfoDatastore.getData().basicLessonUrl;

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
      refreshToken = session.getRefreshToken()!.getToken() ?? "";
      if (idToken.isEmpty || refreshToken.isEmpty) {
        userSub = "";
        return Future.value(null);
      }

      userSub = cloudAuthGateway.getUserSub(idToken) ?? "";
      if (userSub.isEmpty) {
        return Future.value(null);
      }

      generateUrl = "$basicLessonUrl?sub=$userSub&token=$refreshToken";
    }).whenComplete(() {
      final webPageInfo = webPageInfoDatastore.getData();
      webPageInfo.generateUrl = generateUrl;
      webPageInfoDatastore.publish(webPageInfo);

      completer.complete();
    });

    return completer.future;
  }
}
