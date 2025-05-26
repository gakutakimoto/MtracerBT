import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';

import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/residentchannel/swingvideosync_residentchannel.dart';
import 'package:mtracersdkexample/residentchannel_interface/channelcontrol_residentchannel_interface.dart';
import 'package:mtracersdkexample/residentservice_interface/timeperiodic_residentservice_interface.dart';
import 'package:path_provider/path_provider.dart';

class SwingVideoSyncResidentService implements TimePeriodicResidentServiceInterface {
  static final SwingVideoSyncResidentService _instance = SwingVideoSyncResidentService._internal();
  factory SwingVideoSyncResidentService() => _instance;

  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  late ChannelControlResidentChannelInterface swingVideoSyncResidentChannel;
  Timer? _timer;

  SwingVideoSyncResidentService._internal() {
    swingVideoSyncResidentChannel = SwingVideoSyncResidentChannel();

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
    log("同期.待機.31sec");

    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    _timer = Timer(const Duration(seconds: 31), _onAction);
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
        final rootPath = Directory(directory.path + "/" + userId + "/sync/swingvideo/");

        if (rootPath.existsSync()) {
          for (final swingVideoFile in Directory(rootPath.path).listSync()) {
            log("swingVideoFile.path");
            log(swingVideoFile.path);

            final swingVideoFileInfo = basename(swingVideoFile.path).split("_");
            if (swingVideoFileInfo.isNotEmpty) {
              //tbd
              //ファイルサイズ０ならアップせず削除？
              await swingVideoSyncResidentChannel.start(args: {"userId": userId, "swingDate": swingVideoFileInfo[0], "path": swingVideoFile.path, "swingInfoId": basenameWithoutExtension(swingVideoFileInfo[1])});
            }

            // for (final file in Directory(swingDate.path).listSync().where((file) => file.path.endsWith(".mp4"))) {
            //   log("revel2.path");
            //   log(file.path);

            //   //tbd
            //   //ファイルサイズ０ならアップせず削除？
            //   await swingVideoSyncResidentChannel.start(args: {"userId": userId, "swingDate": basename(swingDate.path), "path": file.path, "swingInfoId": basenameWithoutExtension(file.path)});
            // }
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
