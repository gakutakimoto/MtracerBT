import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:mtracersdkexample/appdto/analyzeresult_type.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swinginfos_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/swinginfos_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/localpersistence_gateway.dart';
import 'package:mtracersdkexample/gateway/mtracer_gateway.dart';
import 'package:mtracersdkexample/gateway/parameter_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/localpersistence_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/gatewayinterface/parameter_gatewayinterface.dart';
import 'package:mtracersdkexample/logic/stringcodec_logic.dart';
import 'package:mtracersdkexample/logicinterface/stringcodec_logicinterface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelsubscribe_eventchannel_interface.dart';
import 'package:path_provider/path_provider.dart';

class SwingInfoEventMonitorResidentChannel implements ChannelControlResidentChannelInterface, ChannelSubscribeEventChannelInterface<void Function(SwingEventInfoAppDto), SwingEventInfoAppDto, void Function(SwingInfoAppDto), SwingInfoAppDto, void Function(void), void> {
  static final SwingInfoEventMonitorResidentChannel _instance = SwingInfoEventMonitorResidentChannel._internal();
  factory SwingInfoEventMonitorResidentChannel() => _instance;

  late MTracerGatewayInterface mtracerGateway;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;
  late LocalPersistenceGatewayInterface localPersistenceGateway;

  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(SwingInfosAppDto), SwingInfosAppDto> swingInfosDatastore;

  late bool _isStarted;
  late StreamSubscription? _subscription;
  late Map<String, void Function(SwingEventInfoAppDto)> _eventStartSubscribers;
  late Map<String, void Function(SwingInfoAppDto)> _eventSubscribers;
  late Map<String, void Function(void)> _eventFinishSubscribers;

  SwingInfoEventMonitorResidentChannel._internal() {
    mtracerGateway = MTracerGateway();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();
    localPersistenceGateway = LocalPersistenceGateway();

    //Datastore
    appStateInfoDatastore = AppStateInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    swingInfosDatastore = SwingInfosDatastore();

    _isStarted = false;
    _subscription = null;
    _eventStartSubscribers = {};
    _eventSubscribers = {};
    _eventFinishSubscribers = {};
  }

  @override
  void addEventStartSubscriber(final String key, void Function(SwingEventInfoAppDto) subscriber) {
    _eventStartSubscribers[key] = subscriber;
  }

  @override
  void removeEventStartSubscriber(final String key) {
    _eventStartSubscribers.remove(key);
  }

  @override
  void publishEventStart(final SwingEventInfoAppDto value) {
    _eventStartSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  void addEventSubscriber(final String key, void Function(SwingInfoAppDto) subscriber) {
    _eventSubscribers[key] = subscriber;
  }

  @override
  void removeEventSubscriber(final String key) {
    _eventSubscribers.remove(key);
  }

  @override
  void publishEvent(final SwingInfoAppDto value) {
    _eventSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  void addEventFinishSubscriber(final String key, void Function(void) subscriber) {
    _eventFinishSubscribers[key] = subscriber;
  }

  @override
  void removeEventFinishSubscriber(final String key) {
    _eventFinishSubscribers.remove(key);
  }

  @override
  void publishEventFinish(final void value) {
    _eventFinishSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  Future<void> start({Map<String, dynamic>? args}) {
    log("Swingデータ監視");

    final completer = Completer<void>();

    if (_isStarted) {
      log("Swingデータ監視.開始済み");
      completer.complete();
    } else {
      log("Swingデータ監視.開始");
      _start().then((_) {
        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      });
    }

    return completer.future;
  }

  @override
  void stop() {
    log("Swingデータ監視.終了");

    _isStarted = false;

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  Future<void> _start() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    _subscription = mtracerGateway.receiveSwingInfoEvent(
      userInfo.userId,
      () {
        _onStart();
        completer.complete();
      },
      _onData,
      (error) {
        _onError(error);
        completer.completeError(error);
      },
      true,
    );

    return completer.future;
  }

  void _onStart() {
    log("Swingデータ監視.開始成功");

    _isStarted = true;

    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isStartedSwingInfoEventMonitoring = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  void _onError(error) {
    log("Swingデータ監視.開始失敗");
    log(error);

    _isStarted = false;

    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isStartedSwingInfoEventMonitoring = false;
    appStateInfoDatastore.publish(appStateInfo);

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  Future<void> _onData(final SwingEventInfoAppDto _swingEventInfo) {
    log("Swingデータ監視.保存完了");
    log(_swingEventInfo.index.toString());

    final completer = Completer<void>();

    log("Swingデータ監視.start");
    publishEventStart(_swingEventInfo);

    _readSwing(_swingEventInfo).then((final SwingInfoAppDto swingInfo) {
      log("Swingデータ監視.OK");
      publishEvent(swingInfo);
      completer.complete();
    }).whenComplete(() {
      log("Swingデータ監視.Finish");
      publishEventFinish(null);
    });

    return completer.future;
  }

  Future<SwingInfoAppDto> _readSwing(final SwingEventInfoAppDto _swingEventInfo) async {
    final appStateInfo = appStateInfoDatastore.getData();
    if (appStateInfo.isDeviceLoading) {
      log("Swingデータ監視.通信中");
      throw (Error());
    } else if (!_swingEventInfo.isExist) {
      log("Swingデータ監視.データなし");
      throw (Error());
    }

    log("Swingデータ監視.通信開始");
    appStateInfo.isDeviceLoading = true;
    appStateInfoDatastore.publish(appStateInfo);

    log("Swingデータ監視.データ取得");
    try {
      final swingInfo = await _readSwingInfo(_swingEventInfo.index);
      if (swingInfo.analyzeResultType == AnalyzeResultType.noError || swingInfo.analyzeResultType == AnalyzeResultType.outputErrorAfterImpact) {
        log("Swingデータ監視.解析.正常");
        final encryptedSwingInfo = await _encryptSwingInfo(swingInfo.raw);
        if (encryptedSwingInfo == null) {
          throw (Error());
        }

        final file = await _saveAsLocalFile(swingInfo.swingHeaderInfo.index, swingInfo.swingHeaderInfo.swingInfoId, encryptedSwingInfo);
        if (!file.existsSync()) {
          throw (Error());
        }

        final isPersisted = await _persistSwingInfo(encryptedSwingInfo);
        if (!isPersisted) {
          throw (Error());
        }

        log("Swingデータ監視.データ取得.成功");
        final swingInfosDatastoreData = swingInfosDatastore.getData();
        swingInfosDatastoreData.swingInfos.add(swingInfo);
        swingInfosDatastoreData.currentSwingInfo = swingInfo;
        swingInfosDatastore.publish(swingInfosDatastoreData);
      } else {
        log("Swingデータ監視.解析.異常");
      }

      await _deleteSwingInfo(_swingEventInfo.index);
      return swingInfo;
    } catch (e) {
      log("Swingデータ監視.データ取得.失敗");
      throw (Error());
    } finally {
      log("Swingデータ監視.通信終了");
      appStateInfo.isDeviceLoading = false;
      appStateInfoDatastore.publish(appStateInfo);
    }
  }

  Future<SwingInfoAppDto> _readSwingInfo(final int index) {
    log("データ取得");
    final completer = Completer<SwingInfoAppDto>();

    //tbd
    //addressFaceAngleAdjustTypeを指定する
    final userInfo = userInfoDatastore.getData();
    mtracerGateway.readSwingInfo(userInfo.userId, index, userInfo.userBasicProfileInfo.weight, userInfo.userGolferProfileInfo.scoreAVG, 0).then((final SwingInfoAppDto swingInfo) {
      log("データ取得.成功");
      log(swingInfo.swingHeaderInfo.swingInfoId);

      completer.complete(swingInfo);
    }).catchError((error) {
      log("データ取得.失敗");
      log(error.toString());

      completer.completeError(error);
    });

    return completer.future;
  }

  Future<String?> _encryptSwingInfo(final String rawInfo) async {
    log("データ暗号化");

    late final String encryptedSwingInfo;
    try {
      final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
      final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
      final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
      encryptedSwingInfo = stringCodecLogic.encrypt(decryptKey, decryptIv, rawInfo, mode: AESMode.cbc);
      log("データ暗号化.成功");
      return encryptedSwingInfo;
    } catch (e) {
      log("データ暗号化.失敗");
      log(e.toString());

      return null;
    }
  }

  Future<File> _saveAsLocalFile(final int index, final String swingInfoId, final String data) {
    log("データ保存(ファイル)");

    final completer = Completer<File>();

    final userId = userInfoDatastore.getData().userId;
    getApplicationDocumentsDirectory().then((directory) {
      final file = File(directory.path + "/" + userId + "/sync/swinginfo/" + index.toString() + "_" + swingInfoId + ".dat");

      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
      file.createSync(recursive: true);

      return file.writeAsString(data);
    }).then((file) {
      completer.complete(file);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<bool> _persistSwingInfo(final String encryptedSwingInfo) {
    log("データ保存(プレファレンス)");

    final completer = Completer<bool>();

    final userId = userInfoDatastore.getData().userId;
    localPersistenceGateway.persistSwingInfo(userId, encryptedSwingInfo).then((_) {}).whenComplete(() {
      completer.complete(true);
    });

    return completer.future;
  }

  Future<void> _deleteSwingInfo(final int index) {
    log("データ削除");
    log(index.toString());

    final completer = Completer<void>();

    final userId = userInfoDatastore.getData().userId;
    mtracerGateway.writeUploadFlag(userId, index).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }
}
