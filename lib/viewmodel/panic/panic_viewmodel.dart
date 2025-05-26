import 'package:flutter/material.dart';
import 'package:mtracersdkexample/viewvloc/panic/panic_viewvloc.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';

class PanicViewModel {
  late PanicViewVLoC panicViewVLoC;
  // late DeviceInfoPlugin deviceInfoPlugin;

  PanicViewModel() {
    panicViewVLoC = PanicViewVLoC();
    // deviceInfoPlugin = DeviceInfoPlugin();
  }

  void initState() {}

  void didBuiltView() {}

  void dispose() {}

  void onPressedReStart() {
    // Restart.restartApp();
  }

  Future<void> onPressedContact(final BuildContext context) async {
    // String userId = "";
    // String nickName = "";
    // String osVersion = "";
    // String appVersion = "";

    // try {
    //   final viewInfo = await panicViewVLoC.viewInfo.first;
    //   userId = (viewInfo.userId.isEmpty) ? "取得できませんでした" : viewInfo.userId;
    //   nickName = (viewInfo.nickName.isEmpty) ? "取得できませんでした" : viewInfo.nickName;

    //   if (Platform.isAndroid) {
    //     final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    //     osVersion = "Android OS ${androidDeviceInfo.version.release.toString()} / API-${androidDeviceInfo.version.sdkInt.toString()}";
    //   } else {
    //     final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    //     osVersion = "iOS " + iosDeviceInfo.systemVersion.toString();
    //   }

    //   final packageInfo = await PackageInfo.fromPlatform();
    //   appVersion = packageInfo.version;

    //   final email = Email(
    //     subject: "エムトレGolfエラーお問合せ",
    //     body: "件名、本文の内容を変更せず、このまま送信してください。\n\n"
    //         "お客様よりエムトレGolfにてエラー発生のお問合せです。\n"
    //         "[ID] $userId\n"
    //         "[ニックネーム] $nickName\n"
    //         "[OSバージョン] $osVersion\n"
    //         "[アプリバージョン] $appVersion\n",
    //     recipients: ["support@t3-sports.com"],
    //     isHTML: false,
    //   );

    //   await FlutterEmailSender.send(email);
    // } catch (e) {
    //   showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         title: const AutoSizeText(
    //           "エラー",
    //           maxLines: 1,
    //         ),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: const [
    //             AutoSizeText(
    //               "メールアプリが開けませんでした。",
    //               maxLines: 1,
    //             ),
    //           ],
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const AutoSizeText(
    //               "閉じる",
    //               maxLines: 1,
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}
