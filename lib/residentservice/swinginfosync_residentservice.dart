import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/residentchannel/swinginfosync_residentchannel.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:mtracersdkexample/residentservice_interface/timeperiodic_residentservice_interface.dart';
import 'package:path_provider/path_provider.dart';

class SwingInfoSyncResidentService implements TimePeriodicResidentServiceInterface {
  static final SwingInfoSyncResidentService _instance = SwingInfoSyncResidentService._internal();
  factory SwingInfoSyncResidentService() => _instance;

  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  late ChannelControlResidentChannelInterface swingInfoSyncResidentChannel;
  Timer? _timer;

  SwingInfoSyncResidentService._internal() {
    swingInfoSyncResidentChannel = SwingInfoSyncResidentChannel();

    userInfoDatastore = UserInfoDatastore();

    _timer = null;
  }

  @override
  void start() {
    log("同期.起動");

    _setNextAction();
  }

  @override
  void stop() {
    log("同期.終了");

    _stop();
  }

  void _stop() {
    log("同期.終了.開始");

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void inactive() {
    log("同期.一時停止");

    _stop();
  }

  @override
  void resume() {
    log("同期.再開");

    _setNextAction();
  }

  void _setNextAction() {
    log("同期.待機.29sec");

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    _timer = Timer(const Duration(seconds: 29), _onAction);
  }

  Future<void> _onAction() {
    log("同期.開始");

    final completer = Completer<void>();

    final userId = userInfoDatastore.getData().userId;
    if (userId.isEmpty) {
      _setNextAction();
      completer.complete();
    } else {
      getApplicationDocumentsDirectory().then((directory) async {
        final rootPath = Directory(directory.path + "/" + userId + "/sync/swinginfo/");

        if (rootPath.existsSync()) {
          for (final file in rootPath.listSync().where((file) => file.path.endsWith(".dat"))) {
            log(file.path);
            try {
              await swingInfoSyncResidentChannel.start(args: {"path": file.path});
              file.deleteSync(recursive: true);
            } catch (e) {
              //
            }
          }
        }

        completer.complete();
      }).catchError((error) {
        completer.completeError(error);
      }).whenComplete(() {
        _setNextAction();
      });
    }

    return completer.future;
  }
}
