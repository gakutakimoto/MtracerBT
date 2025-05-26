import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingheaderinfo_appdto.dart';
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
import 'package:path_provider/path_provider.dart';

class SwingInfoMonitorResidentChannel implements ChannelControlResidentChannelInterface {
  static final SwingInfoMonitorResidentChannel _instance = SwingInfoMonitorResidentChannel._internal();
  factory SwingInfoMonitorResidentChannel() => _instance;

  late MTracerGatewayInterface mtracerGateway;
  late ParameterGatewayInterface parameterGateway;
  late StringCodecLogicInterface stringCodecLogic;
  late LocalPersistenceGatewayInterface localPersistenceGateway;

  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(SwingInfosAppDto), SwingInfosAppDto> swingInfosDatastore;

  late StreamSubscription? _subscription;
  late List<SwingHeaderInfoAppDto> swingHeaderInfos;

  SwingInfoMonitorResidentChannel._internal() {
    mtracerGateway = MTracerGateway();
    parameterGateway = ParameterGateway();
    stringCodecLogic = StringCodecLogic();
    localPersistenceGateway = LocalPersistenceGateway();

    //Datastore
    appStateInfoDatastore = AppStateInfoDatastore();
    userInfoDatastore = UserInfoDatastore();
    swingInfosDatastore = SwingInfosDatastore();

    _subscription = null;
    swingHeaderInfos = [];
  }

  @override
  Future<void> start({Map<String, dynamic>? args}) {
    final completer = Completer<void>();
    log("Swingデータ同期");

    log("Swingデータ同期.開始");
    _start().then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @override
  void stop() {
    log("Swingデータ同期.終了");

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  Future<void> _start() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    _subscription = mtracerGateway.readSwingHeaderInfoList(
      userInfo.userId,
      () {
        _onStart();
      },
      _onData,
      () async {
        if (_subscription != null) {
          _subscription!.cancel();
          _subscription = null;
        }

        await _onFinish();
        completer.complete();
      },
      (error) {
        if (_subscription != null) {
          _subscription!.cancel();
          _subscription = null;
        }

        _onError(error);
        completer.completeError(error);
      },
      true,
    );

    return completer.future;
  }

  void _onStart() {
    log("Swingデータ同期.開始成功");

    swingHeaderInfos = [];

    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isStartedSwingImpactEventMonitoring = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  void _onError(error) {
    log("Swingデータ同期.開始失敗");
    log(error);

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  Future<void> _onFinish() async {
    log("Swingデータ同期.データ検出完了");

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    await _readSwingInfos();
  }

  void _onData(final SwingHeaderInfoAppDto swingHeaderInfo) {
    log("Swingデータ同期.データ検出");
    log(swingHeaderInfo.index.toString());

    swingHeaderInfos.add(swingHeaderInfo);
  }

  Future<void> _readSwingInfos() async {
    log("Swingデータ同期.データ取得");
    log(swingHeaderInfos.length.toString());

    for (var swingHeaderInfo in swingHeaderInfos) {
      log(swingHeaderInfo.swingInfoId);

      if (swingHeaderInfo.isBroken) {
        log("Swingデータ同期.データ取得.データ破損");
        return;
      }

      //データ取得
      log("Swingデータ同期.データ取得.開始");
      final userInfo = userInfoDatastore.getData();
      final SwingInfoAppDto newSwingInfo;
      try {
        //tbd
        //addressFaceAngleAdjustTypeを指定する
        newSwingInfo = await mtracerGateway.readSwingInfo(userInfo.userId, swingHeaderInfo.index, userInfo.userBasicProfileInfo.weight, userInfo.userGolferProfileInfo.scoreAVG, 0).timeout(const Duration(seconds: 15));
        log("Swingデータ同期.データ取得.成功");
        log(newSwingInfo.swingHeaderInfo.swingInfoId);
      } catch (e) {
        log("Swingデータ同期.データ取得.失敗");
        log(e.toString());
        return;
      }

      //暗号化
      log("Swingデータ同期.データ暗号化");
      late final String encryptedSwingInfo;
      try {
        final systemParameterInfo = await parameterGateway.readSystemParameterInfo();
        final decryptKey = stringCodecLogic.decode(systemParameterInfo.decryptCBCKey);
        final decryptIv = stringCodecLogic.decode(systemParameterInfo.decryptCBCIv);
        encryptedSwingInfo = stringCodecLogic.encrypt(decryptKey, decryptIv, newSwingInfo.raw, mode: AESMode.cbc);
        log("Swingデータ同期.データ暗号化.成功");
      } catch (e) {
        log("Swingデータ同期.データ暗号化.失敗");
        log(e.toString());

        return;
      }

      //ファイル保存
      log("Swingデータ同期.ファイル保存");
      try {
        final file = await _saveAsLocalFile(swingHeaderInfo.index, newSwingInfo.swingHeaderInfo.swingInfoId, encryptedSwingInfo);
        if (!file.existsSync()) {
          log("Swingデータ同期.ファイル保存.失敗");
          throw Error();
        }
        log("Swingデータ同期.ファイル保存.成功");
      } catch (e) {
        log("Swingデータ同期.ファイル保存.失敗");
        log(e.toString());

        return;
      }

      //プレファレンスへ保存
      log("Swingデータ同期.プレファレンス保存");
      try {
        final isSuccess = await localPersistenceGateway.persistSwingInfo(userInfo.userId, encryptedSwingInfo);
        if (!isSuccess) {
          throw Error();
        }
        log("Swingデータ同期.プレファレンス保存.成功");
      } catch (e) {
        log("Swingデータ同期.プレファレンス保存.失敗");
        log(e.toString());

        return;
      }

      //取得完了
      log("Swingデータ同期.データ消去");
      log(swingHeaderInfo.index.toString());
      try {
        await mtracerGateway.writeUploadFlag(userInfo.userId, swingHeaderInfo.index);
        log("Swingデータ同期.データ消去.成功");
      } catch (e) {
        log("Swingデータ同期.データ消去.失敗");
        log(e.toString());

        return;
      }

      //データ通知
      log("Swingデータ同期.データ通知");
      final swingInfosDatastoreData = swingInfosDatastore.getData();
      swingInfosDatastoreData.swingInfos.add(newSwingInfo);
      swingInfosDatastoreData.currentSwingInfo = newSwingInfo;
      swingInfosDatastore.publish(swingInfosDatastoreData);
    }
  }

  Future<File> _saveAsLocalFile(final int index, final String swingInfoId, final String data) {
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
}
