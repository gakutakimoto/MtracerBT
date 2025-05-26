import 'dart:async';

import 'package:mtracersdkexample/appdto/permissioninfo_appdto.dart';
import 'package:mtracersdkexample/datastore/permissioninfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/serviceinterface/permission_serviceinterface.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends PermissionServiceInterface {
  late DatastoreInterface<void Function(PermissionInfoAppDto), PermissionInfoAppDto> permissionInfoDatastore;

  PermissionService() {
    permissionInfoDatastore = PermissionInfoDatastore();
  }

  @override
  Future<void> requestPermissionForConnect() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    var permissionInfo = permissionInfoDatastore.getData();
    permissionInfo.bluetooth = statuses[Permission.bluetooth] ?? PermissionStatus.denied;
    permissionInfo.bluetoothScan = statuses[Permission.bluetoothScan] ?? PermissionStatus.denied;
    permissionInfo.bluetoothConnect = statuses[Permission.bluetoothConnect] ?? PermissionStatus.denied;
    permissionInfo.location = statuses[Permission.location] ?? PermissionStatus.denied;

    permissionInfoDatastore.publish(permissionInfo);
  }

  @override
  Future<void> requestPermissionForTraining() async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    var permissionInfo = permissionInfoDatastore.getData();
    permissionInfo.camera = statuses[Permission.camera] ?? PermissionStatus.denied;
    permissionInfo.photos = statuses[Permission.photos] ?? PermissionStatus.denied;

    permissionInfoDatastore.publish(permissionInfo);
  }

  @override
  bool isGrantedPermissionForTraining() {
    var permissionInfo = permissionInfoDatastore.getData();
    //memo
    //選択許可はlimitedになる
    //tbd
    //保存はできるんだろうか？
    return (permissionInfo.camera.isGranted && permissionInfo.photos.isGranted);
  }
}
