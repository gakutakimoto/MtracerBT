import 'dart:async';
import 'dart:developer';

import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/residentchannel/swingimpacteventmonitor_residentchannel.dart';
import 'package:mtracersdkexample/residentchannel/swinginfoevent_residentchannel.dart';
import 'package:mtracersdkexample/residentchannel/swinginfomonitor_residentchannel.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:mtracersdkexample/residentservice_interface/timeperiodic_residentservice_interface.dart';

class DeviceMonitorResidentService implements TimePeriodicResidentServiceInterface {
  static final DeviceMonitorResidentService _instance = DeviceMonitorResidentService._internal();
  factory DeviceMonitorResidentService() => _instance;

  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;
  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;

  late ChannelControlResidentChannelInterface swingImpactEventMonitorResidentChannel;
  late ChannelControlResidentChannelInterface swingInfoEventMonitorResidentChannel;
  late ChannelControlResidentChannelInterface swingInfoMonitorResidentChannel;
  Timer? _timer;

  DeviceMonitorResidentService._internal() {
    //Datastore
    //UserInfoDatastore
    userInfoDatastore = UserInfoDatastore();

    //DeviceInfoDatastore
    appStateInfoDatastore = AppStateInfoDatastore();

    swingImpactEventMonitorResidentChannel = SwingImpactEventMonitorResidentChannel();
    swingInfoEventMonitorResidentChannel = SwingInfoEventMonitorResidentChannel();
    swingInfoMonitorResidentChannel = SwingInfoMonitorResidentChannel();

    _timer = null;
  }

  @override
  void start() {
    log("機器同期.起動");

    _setNextAction();
  }

  @override
  void stop() {
    log("機器同期.終了");

    _stop();
  }

  void _stop() {
    log("機器同期.終了.開始");

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    swingImpactEventMonitorResidentChannel.stop();
    swingInfoEventMonitorResidentChannel.stop();
    swingInfoMonitorResidentChannel.stop();
  }

  @override
  void inactive() {
    log("機器同期.一時停止");

    _stop();
  }

  @override
  void resume() {
    log("機器同期.再開");

    _setNextAction();
  }

  void _setNextAction() {
    log("機器同期.待機.23sec");

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    _timer = Timer(const Duration(seconds: 23), _onAction);
  }

  Future<void> _onAction() {
    log("機器同期.開始");

    final completer = Completer<void>();

    if (!appStateInfoDatastore.getData().isDeviceBooking) {
      log("機器同期.開始.予約状況の確認.予約なし");

      _setNextAction();
      completer.complete();
    } else if (userInfoDatastore.getData().userId.isEmpty) {
      log("機器同期.開始.サイン状況の確認.サインなし");
      _setNextAction();
      completer.complete();
    } else if (appStateInfoDatastore.getData().isInTraining) {
      log("機器同期.開始.画面状態.練習中");

      _setNextAction();
      completer.complete();
    } else if (appStateInfoDatastore.getData().isDeviceLoading) {
      log("機器同期.開始.通信状況の確認.通信中");

      _setNextAction();
      completer.complete();
    } else {
      log("機器同期.開始.通信開始");
      final appStateInfo = appStateInfoDatastore.getData();
      appStateInfo.isInSyncing = true;
      appStateInfo.isDeviceLoading = true;
      appStateInfoDatastore.publish(appStateInfo);

      log("機器同期.開始.インパクト監視");
      swingImpactEventMonitorResidentChannel.start().then((_) {
        log("機器同期.開始.データ保存監視");
        return swingInfoEventMonitorResidentChannel.start();
      }).then((_) {
        log("機器同期.開始.データ同期");
        return swingInfoMonitorResidentChannel.start();
      }).then((_) {
        log("機器同期.開始.成功");
      }).catchError((error) {
        log("機器同期.開始.失敗");

        final appStateInfo = appStateInfoDatastore.getData();
        appStateInfo.isStartedSwingImpactEventMonitoring = false;
        appStateInfo.isStartedSwingInfoEventMonitoring = false;
        appStateInfoDatastore.publish(appStateInfo);

        swingImpactEventMonitorResidentChannel.stop();
        swingInfoEventMonitorResidentChannel.stop();
        swingInfoMonitorResidentChannel.stop();
      }).whenComplete(() {
        log("機器同期.開始.完了");

        final appStateInfo = appStateInfoDatastore.getData();
        appStateInfo.isInSyncing = false;
        appStateInfo.isDeviceLoading = false;
        appStateInfoDatastore.publish(appStateInfo);

        _setNextAction();
        completer.complete();
      });
    }

    return completer.future;
  }
}
