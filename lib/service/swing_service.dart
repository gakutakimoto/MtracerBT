import 'dart:async';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:intl/intl.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/deletepaintcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/deleteswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingheadercondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingnextcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/getswingprevcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapecircleinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/paintshapelineinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/registerpaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/registerpaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfos_appdto.dart';
import 'package:mtracersdkexample/appdto/swinglistheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintcirclecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintcircleinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlinecondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updatepaintlineinput_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswingcondition_appdto.dart';
import 'package:mtracersdkexample/appdto/updateswinginput_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userswinginfo_appdto.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/swinginfos_datastore.dart';
import 'package:mtracersdkexample/datastore/swinglistheaderinfos_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/awss3_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudstorage_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/serviceinterface/swing_serviceinterface.dart';
import 'package:path_provider/path_provider.dart';

class SwingService extends SwingServiceInterface {
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;
  late CloudStorageGatewayInterface cloudStorageGateway;

  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(SwingInfosAppDto), SwingInfosAppDto> swingInfosDatastore;
  late DatastoreInterface<void Function(Map<String, List<SwingListHeaderInfoAppDto>>), Map<String, List<SwingListHeaderInfoAppDto>>> swingListHeaderInfosDatastore;

  SwingService() {
    localPersistenceGateway = LocalPersistenceGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();
    cloudStorageGateway = AWSS3Gateway();

    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    swingInfosDatastore = SwingInfosDatastore();
    swingListHeaderInfosDatastore = SwingListHeaderInfosDatastore();
  }

  @override
  Future<File?> downloadSwingVideo(final String url, final String userId, final String swingInfoId) {
    final completer = Completer<File?>();

    late final File? tmpFile;
    cloudStorageGateway.download(url).then((final File? _tmpFile) {
      if (_tmpFile == null) {
        return Future.value(null);
      }

      tmpFile = _tmpFile;
      return getApplicationDocumentsDirectory();
    }).then((final Directory? directory) {
      if (directory == null) {
        completer.complete(null);
      } else {
        final swingVideo = File(directory.path + "/" + userId + "/analyze/swingvideo/" + swingInfoId + ".mp4");
        if (swingVideo.existsSync()) {
          swingVideo.deleteSync();
        }
        swingVideo.createSync(recursive: true);

        tmpFile!.copySync(swingVideo.path);
        tmpFile!.deleteSync(recursive: true);

        completer.complete(swingVideo);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> requestNextSwing() {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;
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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final getSwingNextCondition = GetSwingNextConditionAppDto();
      getSwingNextCondition.userId = userInfo.userId;
      final swingInfoDatastoreData = swingInfosDatastore.getData();
      if (swingInfoDatastoreData.currentSwingInfo == null) {
        getSwingNextCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now().toUtc());
      } else {
        getSwingNextCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(swingInfoDatastoreData.currentSwingInfo!.swingHeaderInfo.swingDate);
      }

      return cloudAPIGateway.getSwingNext(graphQlEndpoint, accessToken, getSwingNextCondition);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(false);
      } else {
        final swingInfoDatastoreData = swingInfosDatastore.getData();

        final duplicated = swingInfoDatastoreData.swingInfos.firstWhere((element) {
          //tbd
          //use swingId
          return element.swingHeaderInfo.swingInfoId == swingInfo.swingHeaderInfo.swingInfoId;
        }, orElse: () {
          return SwingInfoAppDto();
        });

        if (duplicated.swingHeaderInfo.swingInfoId.isEmpty) {
          swingInfoDatastoreData.swingInfos.add(swingInfo);
        }
        swingInfoDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfoDatastoreData);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<bool> requestPrevSwing() {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;
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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final getSwingPrevCondition = GetSwingPrevConditionAppDto();
      getSwingPrevCondition.userId = userInfo.userId;
      final swingInfoDatastoreData = swingInfosDatastore.getData();
      if (swingInfoDatastoreData.currentSwingInfo == null) {
        getSwingPrevCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now().toUtc());
      } else {
        getSwingPrevCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(swingInfoDatastoreData.currentSwingInfo!.swingHeaderInfo.swingDate);
      }

      return cloudAPIGateway.getSwingPrev(graphQlEndpoint, accessToken, getSwingPrevCondition);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(false);
      } else {
        final swingInfoDatastoreData = swingInfosDatastore.getData();

        final duplicated = swingInfoDatastoreData.swingInfos.firstWhere((element) {
          //tbd
          //use swingId
          return element.swingHeaderInfo.swingInfoId == swingInfo.swingHeaderInfo.swingInfoId;
        }, orElse: () {
          return SwingInfoAppDto();
        });

        if (duplicated.swingHeaderInfo.swingInfoId.isEmpty) {
          swingInfoDatastoreData.swingInfos.add(swingInfo);
        }
        swingInfoDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfoDatastoreData);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<bool> requestSwing(final String swingId) {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;
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

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      idToken = session.getIdToken().getJwtToken() ?? "";
      accessToken = session.getAccessToken().getJwtToken() ?? "";
      if (idToken.isEmpty || accessToken.isEmpty) {
        return Future.value(null);
      }

      final getSwingCondition = GetSwingConditionAppDto();
      getSwingCondition.userId = userInfo.userId;
      getSwingCondition.swingId = swingId;

      return cloudAPIGateway.getSwing(graphQlEndpoint, accessToken, getSwingCondition);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(false);
      } else {
        final swingInfoDatastoreData = swingInfosDatastore.getData();

        final duplicated = swingInfoDatastoreData.swingInfos.firstWhere((element) {
          //tbd
          //use swingId
          return element.swingHeaderInfo.swingInfoId == swingInfo.swingHeaderInfo.swingInfoId;
        }, orElse: () {
          return SwingInfoAppDto();
        });

        if (duplicated.swingHeaderInfo.swingInfoId.isEmpty) {
          swingInfoDatastoreData.swingInfos.add(swingInfo);
        }
        swingInfoDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfoDatastoreData);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<bool> requestSwingHeaderInfos(final DateTime swingDateFrom, final DateTime swingDateTo) {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;
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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final getSwingHeaderCondition = GetSwingHeaderConditionAppDto();
      getSwingHeaderCondition.userId = userInfo.userId;

      getSwingHeaderCondition.swingDateFrom = DateFormat("yyyy-MM-dd 00:00:00").format(DateTime(swingDateFrom.year, swingDateFrom.month, swingDateFrom.day));
      getSwingHeaderCondition.swingDateTo = DateFormat("yyyy-MM-dd 23:59:59").format(DateTime(swingDateTo.year, swingDateTo.month, swingDateTo.day));

      //検索範囲日のデータをクリアする
      var swingHeaderInfosDatastoreData = swingListHeaderInfosDatastore.getData();
      final diff = DateTime(swingDateTo.year, swingDateTo.month, swingDateTo.day).difference(DateTime(swingDateFrom.year, swingDateFrom.month, swingDateFrom.day)).inDays;
      for (int i = 0; i < diff; i++) {
        final key = DateFormat("yyyy-MM-dd").format(DateTime(swingDateFrom.year, swingDateFrom.month, swingDateFrom.day).add(Duration(days: i)));
        swingHeaderInfosDatastoreData.remove(key);
      }
      swingListHeaderInfosDatastore.publish(swingHeaderInfosDatastoreData);

      return cloudAPIGateway.getSwingHeader(graphQlEndpoint, accessToken, getSwingHeaderCondition);
    }).then((final List<SwingListHeaderInfoAppDto>? swingListHeaderInfos) {
      if (swingListHeaderInfos == null) {
        completer.complete(false);
      } else {
        var swingHeaderInfosDatastoreData = swingListHeaderInfosDatastore.getData();

        for (var swingListHeaderInfo in swingListHeaderInfos) {
          final swingDateKey = DateFormat("yyyy-MM-dd").format(swingListHeaderInfo.swingListHeaderIndexesInfo.swingDate);
          swingHeaderInfosDatastoreData[swingDateKey] = [];
        }

        for (var swingListHeaderInfo in swingListHeaderInfos) {
          final swingDateKey = DateFormat("yyyy-MM-dd").format(swingListHeaderInfo.swingListHeaderIndexesInfo.swingDate);
          swingHeaderInfosDatastoreData[swingDateKey]!.add(swingListHeaderInfo);
        }

        swingListHeaderInfosDatastore.publish(swingHeaderInfosDatastoreData);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  void reserveDeleteSwing(final String swingId) {
    final data = swingListHeaderInfosDatastore.getData();
    for (var swingListHeaderInfos in data.values) {
      for (var swingListHeaderInfo in swingListHeaderInfos) {
        if (swingListHeaderInfo.swingId == swingId) {
          swingListHeaderInfo.isDeleteReserved = true;
          break;
        }
      }
    }

    swingListHeaderInfosDatastore.publish(data);
  }

  @override
  Future<bool> deleteSwing() {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;

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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final condition = DeleteSwingConditionAppDto();
      final swingListHeaderInfos = swingListHeaderInfosDatastore.getData();
      for (var swingListHeaderInfos in swingListHeaderInfos.values) {
        for (var swingListHeaderInfo in swingListHeaderInfos) {
          if (swingListHeaderInfo.isDeleteReserved) {
            condition.swingIds.add(swingListHeaderInfo.swingId);
          }
        }
      }

      if (condition.swingIds.isEmpty) {
        return Future.value(<SwingListHeaderInfoAppDto>[]);
      } else {
        return cloudAPIGateway.deleteSwing(graphQlEndpoint, accessToken, condition);
      }
    }).then((final List<SwingListHeaderInfoAppDto>? swingListHeaderInfos) {
      if (swingListHeaderInfos == null) {
        completer.complete(false);
      } else {
        final swingListHeaderInfos = swingListHeaderInfosDatastore.getData();
        for (var swingListHeaderInfos in swingListHeaderInfos.values) {
          swingListHeaderInfos.removeWhere((swingListHeaderInfo) => swingListHeaderInfo.isDeleteReserved);
        }
        swingListHeaderInfosDatastore.publish(swingListHeaderInfos);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<DateTime?> searchNextSwing(final DateTime swingDate) {
    final completer = Completer<DateTime?>();

    late final String idToken;
    late final String accessToken;
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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final getSwingNextCondition = GetSwingNextConditionAppDto();
      getSwingNextCondition.userId = userInfo.userId;
      getSwingNextCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(swingDate);

      return cloudAPIGateway.getSwingNext(graphQlEndpoint, accessToken, getSwingNextCondition);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(null);
      } else {
        completer.complete(swingInfo.swingHeaderInfo.swingDate);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<DateTime?> searchPrevSwing(final DateTime swingDate) {
    final completer = Completer<DateTime?>();

    late final String idToken;
    late final String accessToken;
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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final getSwingPrevCondition = GetSwingPrevConditionAppDto();
      getSwingPrevCondition.userId = userInfo.userId;
      getSwingPrevCondition.swingDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(swingDate);

      return cloudAPIGateway.getSwingPrev(graphQlEndpoint, accessToken, getSwingPrevCondition);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(null);
      } else {
        completer.complete(swingInfo.swingHeaderInfo.swingDate);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<bool> toggleFavoriteSwing(final String swingId) {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;

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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final condition = UpdateSwingConditionAppDto();
      condition.swingId = swingId;

      final input = UpdateSwingInputAppDto();
      final data = swingListHeaderInfosDatastore.getData();
      for (var swingListHeaderInfos in data.entries) {
        final swingListHeaderInfo = swingListHeaderInfos.value.firstWhere((swingInfo) => swingInfo.swingId == swingId, orElse: () => SwingListHeaderInfoAppDto());
        if (swingListHeaderInfo.swingId.isNotEmpty) {
          input.isFavorite = !swingListHeaderInfo.isFavorite;
        }
      }
      if (input.isFavorite == null) {
        return Future.value(null);
      }

      return cloudAPIGateway.updateSwing(graphQlEndpoint, accessToken, condition, input);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(false);
      } else {
        final data = swingListHeaderInfosDatastore.getData();
        for (var swingListHeaderInfos in data.entries) {
          final swingListHeaderInfo = swingListHeaderInfos.value.firstWhere((swingInfo) => swingInfo.swingId == swingId, orElse: () => SwingListHeaderInfoAppDto());
          if (swingListHeaderInfo.swingId.isNotEmpty) {
            swingListHeaderInfo.isFavorite = !swingListHeaderInfo.isFavorite;
          }
        }
        swingListHeaderInfosDatastore.publish(data);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<bool> updateMemo(final String swingId, final String? memo) {
    final completer = Completer<bool>();

    late final String idToken;
    late final String accessToken;

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
        return Future.value(null);
      }

      final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;

      final condition = UpdateSwingConditionAppDto();
      condition.swingId = swingId;

      final input = UpdateSwingInputAppDto();
      input.memo = memo;

      return cloudAPIGateway.updateSwing(graphQlEndpoint, accessToken, condition, input);
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete(false);
      } else {
        final data = swingListHeaderInfosDatastore.getData();
        for (var swingListHeaderInfos in data.entries) {
          final swingListHeaderInfo = swingListHeaderInfos.value.firstWhere((swingInfo) => swingInfo.swingId == swingId, orElse: () => SwingListHeaderInfoAppDto());
          if (swingListHeaderInfo.swingId.isNotEmpty) {
            swingListHeaderInfo.memo = memo;
          }
        }
        swingListHeaderInfosDatastore.publish(data);

        completer.complete(true);
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }

  @override
  Future<void> updateSwingPaint(final UserSwingInfoAppDto swingPaintInfo, final String swingId) {
    final completer = Completer<void>();

    late final String idToken;
    late final String accessToken;
    late final graphQlEndpoint = cloudEndpointInfoDatastore.getData().cloudAPIEndpointInfo.graphQlEndpoint;
    final userInfo = userInfoDatastore.getData();
    final userId = userInfo.userId;
    String ownerId = userInfo.userId;

    cloudAuthGateway.getCurrentUser().then((final CognitoUser? cognitoUser) {
      if (cognitoUser == null) {
        return Future.value(null);
      }

      return cognitoUser.getSession();
    }).then((final CognitoUserSession? session) async {
      if (session == null) {
        return Future.value(null);
      }

      idToken = session.getIdToken().getJwtToken() ?? "";
      accessToken = session.getAccessToken().getJwtToken() ?? "";
      if (idToken.isEmpty || accessToken.isEmpty) {
        return Future.value(null);
      }

      int unUpdateCount = 0;
      for (var paintShapeInfo in swingPaintInfo.paintShapeInfos) {
        if (paintShapeInfo.ownerId != "") {
          ownerId = paintShapeInfo.ownerId;
        }

        if (!paintShapeInfo.isValid && !paintShapeInfo.isRegistered && !paintShapeInfo.isUpdated && paintShapeInfo.isDeleted) {
          //Delete :　新規追加→図形移動あり→削除済み
          final deletePaintCondition = DeletePaintConditionAppDto();
          deletePaintCondition.userId = userId;
          deletePaintCondition.swingId = swingId;
          deletePaintCondition.paintId = paintShapeInfo.paintId;

          if (paintShapeInfo is PaintShapeCircleInfoAppDto) {
            await cloudAPIGateway.deletePaint(graphQlEndpoint, accessToken, deletePaintCondition);
          } else if (paintShapeInfo is PaintShapeLineInfoAppDto) {
            await cloudAPIGateway.deletePaint(graphQlEndpoint, accessToken, deletePaintCondition);
          } else {}
        } else if (!paintShapeInfo.isValid && !paintShapeInfo.isRegistered && paintShapeInfo.isUpdated && paintShapeInfo.isDeleted) {
          //Delete :　新規追加→図形移動なし→削除済み
          final deletePaintCondition = DeletePaintConditionAppDto();
          deletePaintCondition.userId = userId;
          deletePaintCondition.swingId = swingId;
          deletePaintCondition.paintId = paintShapeInfo.paintId;

          if (paintShapeInfo is PaintShapeCircleInfoAppDto) {
            await cloudAPIGateway.deletePaint(graphQlEndpoint, accessToken, deletePaintCondition);
          } else if (paintShapeInfo is PaintShapeLineInfoAppDto) {
            await cloudAPIGateway.deletePaint(graphQlEndpoint, accessToken, deletePaintCondition);
          } else {}
        } else if (paintShapeInfo.isValid && !paintShapeInfo.isRegistered && paintShapeInfo.isUpdated && !paintShapeInfo.isDeleted) {
          //Update : サーバーに登録済みで削除されていない

          if (paintShapeInfo is PaintShapeCircleInfoAppDto) {
            final updatePaintCircleCondition = UpdatePaintCircleConditionAppDto();
            updatePaintCircleCondition.userId = userId;
            updatePaintCircleCondition.swingId = swingId;
            updatePaintCircleCondition.paintId = paintShapeInfo.paintId;

            final updatePaintCircleInputAppDto = UpdatePaintCircleInputAppDto();
            updatePaintCircleInputAppDto.centerX = paintShapeInfo.center.dx;
            updatePaintCircleInputAppDto.centerY = paintShapeInfo.center.dy;
            updatePaintCircleInputAppDto.radius = paintShapeInfo.radius;
            updatePaintCircleInputAppDto.color = paintShapeInfo.color;
            updatePaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;

            await cloudAPIGateway.updatePaintCircle(graphQlEndpoint, accessToken, updatePaintCircleCondition, updatePaintCircleInputAppDto);
          } else if (paintShapeInfo is PaintShapeLineInfoAppDto) {
            final updatePaintLineCondition = UpdatePaintLineConditionAppDto();
            updatePaintLineCondition.userId = userId;
            updatePaintLineCondition.swingId = swingId;
            updatePaintLineCondition.paintId = paintShapeInfo.paintId;

            final updatePaintCircleInputAppDto = UpdatePaintLineInputAppDto();
            updatePaintCircleInputAppDto.startX = paintShapeInfo.start.dx;
            updatePaintCircleInputAppDto.startY = paintShapeInfo.start.dy;
            updatePaintCircleInputAppDto.endX = paintShapeInfo.end.dx;
            updatePaintCircleInputAppDto.endY = paintShapeInfo.end.dy;
            updatePaintCircleInputAppDto.color = paintShapeInfo.color;
            updatePaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;

            await cloudAPIGateway.updatePaintLine(graphQlEndpoint, accessToken, updatePaintLineCondition, updatePaintCircleInputAppDto);
          } else {}
        } else if (paintShapeInfo.isValid && paintShapeInfo.isRegistered && !paintShapeInfo.isUpdated && !paintShapeInfo.isDeleted) {
          //Register : 新規追加後、移動なし
          if (paintShapeInfo is PaintShapeCircleInfoAppDto) {
            final registerPaintCircleInputAppDto = RegisterPaintCircleInputAppDto();
            registerPaintCircleInputAppDto.userId = userId;
            registerPaintCircleInputAppDto.swingId = swingId;
            registerPaintCircleInputAppDto.paintId = paintShapeInfo.paintId;
            registerPaintCircleInputAppDto.ownerId = paintShapeInfo.ownerId;

            registerPaintCircleInputAppDto.centerX = paintShapeInfo.center.dx;
            registerPaintCircleInputAppDto.centerY = paintShapeInfo.center.dy;
            registerPaintCircleInputAppDto.radius = paintShapeInfo.radius;
            registerPaintCircleInputAppDto.color = paintShapeInfo.color;
            registerPaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;

            await cloudAPIGateway.registerPaintCircle(graphQlEndpoint, accessToken, registerPaintCircleInputAppDto);
          } else if (paintShapeInfo is PaintShapeLineInfoAppDto) {
            final registerPaintCircleInputAppDto = RegisterPaintLineInputAppDto();
            registerPaintCircleInputAppDto.userId = userId;
            registerPaintCircleInputAppDto.swingId = swingId;
            registerPaintCircleInputAppDto.paintId = paintShapeInfo.paintId;
            registerPaintCircleInputAppDto.ownerId = paintShapeInfo.ownerId;

            registerPaintCircleInputAppDto.startX = paintShapeInfo.start.dx;
            registerPaintCircleInputAppDto.startY = paintShapeInfo.start.dy;
            registerPaintCircleInputAppDto.endX = paintShapeInfo.end.dx;
            registerPaintCircleInputAppDto.endY = paintShapeInfo.end.dy;
            registerPaintCircleInputAppDto.color = paintShapeInfo.color;
            registerPaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;

            await cloudAPIGateway.registerPaintLine(graphQlEndpoint, accessToken, registerPaintCircleInputAppDto);
          } else {}
        } else if (paintShapeInfo.isValid && paintShapeInfo.isRegistered && paintShapeInfo.isUpdated && !paintShapeInfo.isDeleted) {
          //Register : 新規追加後、移動あり
          if (paintShapeInfo is PaintShapeCircleInfoAppDto) {
            final registerPaintCircleInputAppDto = RegisterPaintCircleInputAppDto();
            registerPaintCircleInputAppDto.userId = userId;
            registerPaintCircleInputAppDto.swingId = swingId;
            registerPaintCircleInputAppDto.paintId = paintShapeInfo.paintId;
            registerPaintCircleInputAppDto.ownerId = paintShapeInfo.ownerId;

            registerPaintCircleInputAppDto.centerX = paintShapeInfo.center.dx;
            registerPaintCircleInputAppDto.centerY = paintShapeInfo.center.dy;
            registerPaintCircleInputAppDto.radius = paintShapeInfo.radius;
            registerPaintCircleInputAppDto.color = paintShapeInfo.color;
            registerPaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;

            await cloudAPIGateway.registerPaintCircle(graphQlEndpoint, accessToken, registerPaintCircleInputAppDto);
          } else if (paintShapeInfo is PaintShapeLineInfoAppDto) {
            final registerPaintCircleInputAppDto = RegisterPaintLineInputAppDto();
            registerPaintCircleInputAppDto.userId = userId;
            registerPaintCircleInputAppDto.swingId = swingId;
            registerPaintCircleInputAppDto.paintId = paintShapeInfo.paintId;
            registerPaintCircleInputAppDto.ownerId = ownerId;

            registerPaintCircleInputAppDto.startX = paintShapeInfo.start.dx;
            registerPaintCircleInputAppDto.startY = paintShapeInfo.start.dy;
            registerPaintCircleInputAppDto.endX = paintShapeInfo.end.dx;
            registerPaintCircleInputAppDto.endY = paintShapeInfo.end.dy;
            registerPaintCircleInputAppDto.color = paintShapeInfo.color;
            registerPaintCircleInputAppDto.displayOrder = paintShapeInfo.displayOrder;
            await cloudAPIGateway.registerPaintLine(graphQlEndpoint, accessToken, registerPaintCircleInputAppDto);
          } else {
            //
          }
        } else {
          unUpdateCount++;
        }
      }

      if (unUpdateCount == swingPaintInfo.paintShapeInfos.length) {
        return Future.value(null);
      } else {
        final getSwingCondition = GetSwingConditionAppDto();
        getSwingCondition.userId = userId;
        getSwingCondition.swingId = swingId;

        return cloudAPIGateway.getSwing(graphQlEndpoint, accessToken, getSwingCondition);
      }
    }).then((final SwingInfoAppDto? swingInfo) {
      if (swingInfo == null) {
        completer.complete();
      } else {
        final swingInfoDatastoreData = swingInfosDatastore.getData();

        final duplicated = swingInfoDatastoreData.swingInfos.firstWhere((element) {
          //tbd
          //use swingId
          return element.swingHeaderInfo.swingInfoId == swingInfo.swingHeaderInfo.swingInfoId;
        }, orElse: () {
          return SwingInfoAppDto();
        });

        if (duplicated.swingHeaderInfo.swingInfoId.isEmpty) {
          swingInfoDatastoreData.swingInfos.add(swingInfo);
        }
        swingInfoDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfoDatastoreData);

        completer.complete();
      }
    }).catchError((e) {
      completer.completeError(e);
    });

    return completer.future;
  }
}
