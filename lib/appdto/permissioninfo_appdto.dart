import 'package:permission_handler/permission_handler.dart';

class PermissionInfoAppDto {
  late PermissionStatus camera;
  late PermissionStatus photos;
  late PermissionStatus bluetooth;
  late PermissionStatus bluetoothScan;
  late PermissionStatus bluetoothConnect;
  late PermissionStatus location;

  PermissionInfoAppDto() {
    camera = PermissionStatus.permanentlyDenied;
    photos = PermissionStatus.permanentlyDenied;
    bluetooth = PermissionStatus.permanentlyDenied;
    bluetoothScan = PermissionStatus.permanentlyDenied;
    bluetoothConnect = PermissionStatus.permanentlyDenied;
    location = PermissionStatus.permanentlyDenied;
  }
}
