import 'dart:async';
import 'dart:developer';

import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/swingeventinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/appstateinfo_datastore.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/gateway/mtracer_gateway.dart';
import 'package:mtracersdkexample/gatewayinterface/mtracer_gatewayinterface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelsubscribe_eventchannel_interface.dart';

class SwingImpactEventMonitorResidentChannel implements ChannelControlResidentChannelInterface, ChannelSubscribeEventChannelInterface<void Function(String), String, void Function(SwingEventInfoAppDto), SwingEventInfoAppDto, void Function(String), String> {
  static final SwingImpactEventMonitorResidentChannel _instance = SwingImpactEventMonitorResidentChannel._internal();
  factory SwingImpactEventMonitorResidentChannel() => _instance;

  late MTracerGatewayInterface mtracerGateway;

  late DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> appStateInfoDatastore;
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  late bool _isStarted;
  late StreamSubscription? _subscription;
  late Map<String, void Function(String)> _eventStartSubscribers;
  late Map<String, void Function(SwingEventInfoAppDto)> _eventSubscribers;
  late Map<String, void Function(String)> _eventFinishSubscribers;

  SwingImpactEventMonitorResidentChannel._internal() {
    mtracerGateway = MTracerGateway();

    //Datastore
    //AppStateInfoDatastore
    appStateInfoDatastore = AppStateInfoDatastore();
    //UserInfoDatastore
    userInfoDatastore = UserInfoDatastore();

    _isStarted = false;
    _subscription = null;
    _eventStartSubscribers = {};
    _eventSubscribers = {};
    _eventFinishSubscribers = {};
  }

  @override
  void addEventStartSubscriber(final String key, void Function(String) subscriber) {
    _eventStartSubscribers[key] = subscriber;
  }

  @override
  void removeEventStartSubscriber(final String key) {
    _eventStartSubscribers.remove(key);
  }

  @override
  void publishEventStart(final String value) {
    _eventStartSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  void addEventSubscriber(final String key, void Function(SwingEventInfoAppDto) subscriber) {
    _eventSubscribers[key] = subscriber;
  }

  @override
  void removeEventSubscriber(final String key) {
    _eventSubscribers.remove(key);
  }

  @override
  void publishEvent(final SwingEventInfoAppDto value) {
    _eventSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  void addEventFinishSubscriber(final String key, void Function(String) subscriber) {
    _eventFinishSubscribers[key] = subscriber;
  }

  @override
  void removeEventFinishSubscriber(final String key) {
    _eventFinishSubscribers.remove(key);
  }

  @override
  void publishEventFinish(final String value) {
    _eventFinishSubscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }

  @override
  Future<void> start({Map<String, dynamic>? args}) {
    log("インパクト監視");

    final completer = Completer<void>();

    if (_isStarted) {
      log("インパクト監視.開始済み");
      completer.complete();
    } else {
      log("インパクト監視.開始");
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
    log("インパクト監視.終了");

    _isStarted = false;

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  Future<void> _start() {
    final completer = Completer<void>();

    final userInfo = userInfoDatastore.getData();
    _subscription = mtracerGateway.receiveImpactEvent(
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
    log("インパクト監視.開始成功");

    _isStarted = true;

    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isStartedSwingImpactEventMonitoring = true;
    appStateInfoDatastore.publish(appStateInfo);
  }

  void _onError(error) {
    log("インパクト監視.開始失敗");
    log(error);

    _isStarted = false;

    final appStateInfo = appStateInfoDatastore.getData();
    appStateInfo.isStartedSwingImpactEventMonitoring = false;
    appStateInfoDatastore.publish(appStateInfo);

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  void _onData(final SwingEventInfoAppDto swingEventInfo) {
    log("インパクト監視.インパクト");
    log(swingEventInfo.impactId);

    publishEvent(swingEventInfo);
  }
}
