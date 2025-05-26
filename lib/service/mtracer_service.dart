import 'dart:async';
import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/clubinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/fwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/hwinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/productinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/profileinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/registeruseractivateinput_appdto.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfos_appdto.dart';
import 'package:mtracersdkexample/appdto/useractivateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/advertizeinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/cloudendpointinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/deviceinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/swinginfos_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/awsappsync_gateway.dart';
import 'package:mtracersdkexample/gateway/awscognito_gateway.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gateway/mtracer_gateway.dart';
import 'package:mtracersdkexample/gateway/nfc_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudapi_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/cloudauth_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/nfc_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logic/swing_logic.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/logicinterface/swing_logicinterface.dart';
import 'package:mtracersdkexample/serviceinterface/mtracer_serviceinterface.dart';

class MTracerService extends MTracerServiceInterface {
  late NFCGatewayInterface nfcGateway;
  late MTracerGatewayInterface mtracerGateway;
  late CloudAuthGatewayInterface cloudAuthGateway;
  late CloudAPIGatewayInterface cloudAPIGateway;
  late LocalPersistenceGatewayInterface localPersistenceGateway;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;
  late SwingLogicInterface swingLogic;

  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> cloudEndpointInfoDatastore;
  late DatastoreInterface<void Function(DeviceInfoAppDto), DeviceInfoAppDto> deviceInfoDatastore;
  late DatastoreInterface<void Function(List<String>), List<String>> advertizeInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;
  late DatastoreInterface<void Function(SwingInfosAppDto), SwingInfosAppDto> swingInfosDatastore;

  MTracerService() {
    nfcGateway = NFCGateway();
    mtracerGateway = MTracerGateway();
    cloudAuthGateway = AWSCognitoGateway();
    cloudAPIGateway = AWSAppSyncGateway();
    localPersistenceGateway = LocalPersistenceGateway();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();
    swingLogic = SwingLogic();

    userInfoDatastore = UserInfoDatastore();
    cloudEndpointInfoDatastore = CloudEndpointInfoDatastore();
    deviceInfoDatastore = DeviceInfoDatastore();
    advertizeInfoDatastore = AdvertizeInfoDatastore();
    appStateInfoDatastore = AppStateInfoDatastore();
    swingInfosDatastore = SwingInfosDatastore();
  }

  @override
  Future<void> bookConnection() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();

    localPersistenceGateway.readDeviceUUIDInfo(userInfo.userId).timeout(const Duration(seconds: 15)).then((final String? uuid) {
      if (uuid == null) {
        return Future.value(false);
      } else {
        return mtracerGateway.bookConnection(uuid);
      }
    }).then((final bool isDone) {
      final data = appStateInfoDatastore.getData();
      if (isDone) {
        data.isDeviceBooking = true;
      } else {
        data.isDeviceBooking = false;
      }
      appStateInfoDatastore.publish(data);

      completer.complete();
    }).catchError((error) {
      final appStateInfo = appStateInfoDatastore.getData();
      appStateInfo.isDeviceBooking = false;
      appStateInfoDatastore.publish(appStateInfo);

      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> cancelConnectViaNFC() {
    final completer = Completer<void>();

    nfcGateway.sleepNFCReader().then((_) {
      completer.complete();
    });

    return completer.future;
  }

  @override
  Future<bool> connectViaAdvertize(final String localName) {
    final completer = Completer<bool>();

    final userInfo = userInfoDatastore.getData();
    late final String uuid;
    late final deviceInfo = DeviceInfoAppDto();

    mtracerGateway.disconnect().whenComplete(() {
      mtracerGateway.connect(localName, userInfo.userId).timeout(const Duration(seconds: 15)).then((final String _uuid) {
        if (_uuid.isEmpty) {
          return Future.value(false);
        }

        uuid = _uuid;

        //ユーザー書き込み
        final mtProfileInfo = ProfileInfoAppDto();
        mtProfileInfo.height = userInfo.userBasicProfileInfo.height;
        mtProfileInfo.genderType = userInfo.userBasicProfileInfo.genderType;
        mtProfileInfo.birthdayYMD = (userInfo.userBasicProfileInfo.birthday == null) ? DateTime.utc(1900, 1, 1) : userInfo.userBasicProfileInfo.birthday!;
        return mtracerGateway.writeProfileInfo(userInfo.userId, mtProfileInfo).timeout(const Duration(seconds: 15));
      }).then((final bool isSuccess) {
        if (isSuccess) {
          //機器情報取得
          return _readDeviceInfo(userInfo.userId);
        } else {
          return Future.value(null);
        }
      }).then((final DeviceInfoAppDto? _deviceInfo) {
        if (_deviceInfo == null) {
          return Future.value(null);
        } else {
          return _activate(userInfo.userId, _deviceInfo);
        }
      }).then((final UserActivateInfoAppDto? userActivateInfo) {
        if (userActivateInfo == null) {
          return Future.value(false);
        } else {
          deviceInfo.modelName = userActivateInfo.modelName;
          deviceInfo.serialNo = userActivateInfo.serialNo;
          deviceInfo.fwVersion = userActivateInfo.fwVersion;

          return localPersistenceGateway.persistDeviceInfo(userInfo.userId, deviceInfo);
        }
      }).then((final bool isSuccess) {
        if (isSuccess) {
          final data = deviceInfoDatastore.getData();
          data.modelName = deviceInfo.modelName;
          data.serialNo = deviceInfo.serialNo;
          data.fwVersion = deviceInfo.fwVersion;
          deviceInfoDatastore.publish(data);

          return localPersistenceGateway.persistDeviceUUIDInfo(userInfo.userId, uuid);
        } else {
          return Future.value(false);
        }
      }).then((final bool isSuccess) async {
        if (isSuccess) {
          final data = appStateInfoDatastore.getData();
          data.isDeviceBooking = true;
          appStateInfoDatastore.publish(data);

          completer.complete(true);
        } else {
          final appStateInfo = appStateInfoDatastore.getData();
          appStateInfo.isDeviceBooking = false;
          appStateInfoDatastore.publish(appStateInfo);

          completer.complete(false);
        }
      }).catchError((error) {
        final appStateInfo = appStateInfoDatastore.getData();
        appStateInfo.isDeviceBooking = false;
        appStateInfoDatastore.publish(appStateInfo);

        completer.completeError(error);
      });
    });

    return completer.future;
  }

  @override
  Future<bool> connectViaNFC() {
    final completer = Completer<bool>();

    final userInfo = userInfoDatastore.getData();
    late final String uuid;
    late final deviceInfo = DeviceInfoAppDto();

    mtracerGateway.disconnect().then((value) {
      //
      log("disconnect done");
    }).catchError((error) {
      //
      log("disconnect error");
      log(error.toString());
    }).whenComplete(() {
      nfcGateway.wakeupNFCReader().then((final String localName) {
        if (localName.isEmpty) {
          return Future.value("");
        }

        return mtracerGateway.connect(localName, userInfo.userId).timeout(const Duration(seconds: 15));
      }).then((final String _uuid) {
        if (_uuid.isEmpty) {
          return Future.value(false);
        }

        uuid = _uuid;

        //ユーザー書き込み
        final mtProfileInfo = ProfileInfoAppDto();
        mtProfileInfo.height = userInfo.userBasicProfileInfo.height;
        mtProfileInfo.genderType = userInfo.userBasicProfileInfo.genderType;
        mtProfileInfo.birthdayYMD = (userInfo.userBasicProfileInfo.birthday == null) ? DateTime.utc(1900, 1, 1) : userInfo.userBasicProfileInfo.birthday!;
        return mtracerGateway.writeProfileInfo(userInfo.userId, mtProfileInfo).timeout(const Duration(seconds: 15));
      }).then((final bool isSuccess) {
        if (isSuccess) {
          //機器情報取得
          return _readDeviceInfo(userInfo.userId);
        } else {
          return Future.value(null);
        }
      }).then((final DeviceInfoAppDto? _deviceInfo) {
        if (_deviceInfo == null) {
          return Future.value(null);
        } else {
          return _activate(userInfo.userId, _deviceInfo);
        }
      }).then((final UserActivateInfoAppDto? userActivateInfo) {
        if (userActivateInfo == null) {
          return Future.value(false);
        } else {
          deviceInfo.modelName = userActivateInfo.modelName;
          deviceInfo.serialNo = userActivateInfo.serialNo;
          deviceInfo.fwVersion = userActivateInfo.fwVersion;

          return localPersistenceGateway.persistDeviceInfo(userInfo.userId, deviceInfo);
        }
      }).then((final bool isSuccess) {
        if (isSuccess) {
          final data = deviceInfoDatastore.getData();
          data.modelName = deviceInfo.modelName;
          data.serialNo = deviceInfo.serialNo;
          data.fwVersion = deviceInfo.fwVersion;
          deviceInfoDatastore.publish(data);

          return localPersistenceGateway.persistDeviceUUIDInfo(userInfo.userId, uuid);
        } else {
          return Future.value(false);
        }
      }).then((final bool isSuccess) {
        if (isSuccess) {
          final data = appStateInfoDatastore.getData();
          data.isDeviceBooking = true;
          appStateInfoDatastore.publish(data);
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      }).catchError((error) {
        completer.completeError(error);
      });
    });

    return completer.future;
  }

  @override
  Future<void> disconnect() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    mtracerGateway.disconnect().timeout(const Duration(seconds: 15)).then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> readBatteryLevel() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    mtracerGateway.readBatteryLevel(userInfo.userId).timeout(const Duration(seconds: 15)).then((final int batteryLevel) {
      log("batteryLevel");
      log(batteryLevel.toString());

      final data = deviceInfoDatastore.getData();
      data.batteryLevel = batteryLevel;
      deviceInfoDatastore.publish(data);

      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<bool> readLocalDeviceInfo() {
    final completer = Completer<bool>();

    final userInfo = userInfoDatastore.getData();
    localPersistenceGateway.readDeviceInfo(userInfo.userId).then((final DeviceInfoAppDto? deviceInfo) {
      if (deviceInfo == null) {
        completer.complete(false);
      } else {
        final data = deviceInfoDatastore.getData();
        data.fwVersion = deviceInfo.fwVersion;
        data.serialNo = deviceInfo.serialNo;
        data.modelName = deviceInfo.modelName;
        deviceInfoDatastore.publish(data);
        completer.complete(true);
      }
    }).catchError((error) {
      completer.complete(false);
    });

    return completer.future;
  }

  @override
  Future<void> readLocalSwingInfo() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();

    localPersistenceGateway.readSwingInfo(userInfo.userId).then((final String? encryptValue) async {
      if (encryptValue != null) {
        final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
        final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
        final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
        final decryptValue = stringCodecLogic.decrypt(decryptKey, decryptIv, encryptValue, mode: AESMode.cbc);
        final swingInfo = swingLogic.convertFromJson(decryptValue);
        final swingInfosDatastoreData = swingInfosDatastore.getData();
        swingInfosDatastoreData.swingInfos.add(swingInfo);
        swingInfosDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfosDatastoreData);
      }

      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<SwingInfoAppDto> readSwingInfo(final int index) {
    final completer = Completer<SwingInfoAppDto>();

    final userInfo = userInfoDatastore.getData();

    mtracerGateway.readSwingInfo(userInfo.userId, index, userInfo.userBasicProfileInfo.weight, userInfo.userGolferProfileInfo.scoreAVG, 0).timeout(const Duration(seconds: 15)).then((final SwingInfoAppDto swingInfo) {
      completer.complete(swingInfo);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<int> readSwingInfoCount() {
    final completer = Completer<int>();

    final userInfo = userInfoDatastore.getData();
    late StreamSubscription? subscription;
    int count = 0;
    subscription = mtracerGateway.readSwingHeaderInfoList(
      userInfo.userId,
      () {
        log("readSwingInfoCount.onStart");
        count = 0;
      },
      (final SwingHeaderInfoAppDto swingHeaderInfo) {
        log("readSwingInfoCount.onData");
        count++;
        log("count");
        log(count.toString());
      },
      () {
        log("readSwingInfoCount.onFinish");

        if (subscription != null) {
          subscription!.cancel();
          subscription = null;
        }

        completer.complete(count);
      },
      (error) {
        log("readSwingInfoCount.onError");

        if (subscription != null) {
          subscription!.cancel();
          subscription = null;
        }

        completer.completeError(Error());
      },
      true,
    );

    return completer.future;
  }

  @override
  StreamSubscription receiveImpactEvent(final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError) {
    final userInfo = userInfoDatastore.getData();

    return mtracerGateway.receiveImpactEvent(
      userInfo.userId,
      () {
        onStart();
      },
      onData,
      (error) {
        onError(error);
      },
      true,
    );
  }

  @override
  StreamSubscription receiveSwingInfoEvent(final Function onStart, void Function(SwingEventInfoAppDto) onData, final Function onError) {
    final userInfo = userInfoDatastore.getData();

    return mtracerGateway.receiveSwingInfoEvent(
      userInfo.userId,
      () {
        onStart();
      },
      onData,
      (error) {
        onError(error);
      },
      true,
    );
  }

  @override
  StreamSubscription startScan(final Function onStart, final Function onError) {
    advertizeInfoDatastore.publish([]);

    return mtracerGateway.startScan(
      onStart,
      (final String localName) {
        final data = advertizeInfoDatastore.getData();
        data.add(localName);
        advertizeInfoDatastore.publish(data);
      },
      onError,
      true,
    );
  }

  @override
  Future<bool> updateDeviceInfo() {
    final completer = Completer<bool>();

    final userInfo = userInfoDatastore.getData();
    _readDeviceInfo(userInfo.userId).then((final deviceInfo) {
      if (deviceInfo != null) {
        final data = deviceInfoDatastore.getData();
        data.fwVersion = deviceInfo.fwVersion;
        data.serialNo = deviceInfo.serialNo;
        data.modelName = deviceInfo.modelName;
        deviceInfoDatastore.publish(data);
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    }).catchError((error) {
      completer.complete(false);
    });

    return completer.future;
  }

  @override
  Future<void> writeClubInfo() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();

    final clubInfo = ClubInfoAppDto();
    clubInfo.clubId = "10000000000100000005";
    clubInfo.clubLength = 1.1557;
    clubInfo.faceAngle = -1.0;
    clubInfo.lieAngle = 58.0;
    clubInfo.loftAngle = 10.5;

    mtracerGateway.writeClubInfo(userInfo.userId, clubInfo).timeout(const Duration(seconds: 15)).then((final bool isSuccess) {
      if (isSuccess) {
        completer.complete();
      } else {
        completer.completeError(Error());
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> writeProfileInfo() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    final mtProfileInfo = ProfileInfoAppDto();
    mtProfileInfo.height = userInfo.userBasicProfileInfo.height;
    mtProfileInfo.genderType = userInfo.userBasicProfileInfo.genderType;
    mtProfileInfo.birthdayYMD = (userInfo.userBasicProfileInfo.birthday == null) ? DateTime.utc(1900, 1, 1) : userInfo.userBasicProfileInfo.birthday!;
    mtracerGateway.writeProfileInfo(userInfo.userId, mtProfileInfo).timeout(const Duration(seconds: 15)).then((final bool isSuccess) {
      if (isSuccess) {
        completer.complete();
      } else {
        completer.completeError(Error());
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  Future<void> writeUploadFlag(final int index) {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    mtracerGateway.writeUploadFlag(userInfo.userId, index).timeout(const Duration(seconds: 15)).then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<DeviceInfoAppDto?> _readDeviceInfo(final String userId) {
    final completer = Completer<DeviceInfoAppDto?>();

    final deviceInfo = DeviceInfoAppDto();
    deviceInfo.batteryLevel = 0;

    mtracerGateway.readProductInfo(userId).timeout(const Duration(seconds: 15)).then((final ProductInfoAppDto productInfo) {
      deviceInfo.modelName = productInfo.modelName;
      return mtracerGateway.readHWInfo(userId).timeout(const Duration(seconds: 15));
    }).then((final HWInfoAppDto hwInfo) {
      deviceInfo.serialNo = hwInfo.serialNo;
      return mtracerGateway.readFWInfo(userId).timeout(const Duration(seconds: 15));
    }).then((final FWInfoAppDto fwInfo) {
      deviceInfo.fwVersion = fwInfo.versionNo;

      completer.complete(deviceInfo);
    }).catchError((error) {
      completer.complete(null);
    });

    return completer.future;
  }

  Future<UserActivateInfoAppDto?> _activate(final String userId, final DeviceInfoAppDto deviceInfo) {
    final completer = Completer<UserActivateInfoAppDto?>();

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

      final idToken = _session.getIdToken().getJwtToken() ?? "";
      accessToken = _session.getAccessToken().getJwtToken() ?? "";

      if (idToken.isEmpty || accessToken.isEmpty) {
        return Future.value(null);
      }

      return Future.value(cloudAuthGateway.getUserSub(idToken));
    }).then((final String? userSub) async {
      if (userSub == null) {
        return Future.value(UserActivateInfoAppDto());
      }

      // final userActivateInfo = UserActivateInfoAppDto();
      // userActivateInfo.userId = userId;
      // userActivateInfo.modelName = deviceInfo.modelName;
      // userActivateInfo.serialNo = deviceInfo.serialNo;
      // userActivateInfo.fwVersion = deviceInfo.fwVersion;

      final input = RegisterUserActivateInputAppDto();
      input.userId = userId;
      input.modelName = deviceInfo.modelName;
      input.serialNo = deviceInfo.serialNo;
      input.fwVersion = deviceInfo.fwVersion;
      return cloudAPIGateway.registerUserActivate(cloudEndpointInfo.cloudAPIEndpointInfo.graphQlEndpoint, accessToken, input).timeout(const Duration(seconds: 15));
    }).then((final UserActivateInfoAppDto? userActivateInfo) {
      if (userActivateInfo == null) {
        completer.complete(null);
      } else {
        completer.complete(userActivateInfo);
      }
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
