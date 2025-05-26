import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';

abstract class LocalPersistenceGatewayInterface {
  Future<UserInfoAppDto?> readUserInfo(final String userSub);
  Future<bool> persistUserInfo(final String userSub, final UserInfoAppDto value);
  Future<bool> removeUserInfo(final String userSub);

  Future<String?> readDeviceUUIDInfo(final String userId);
  Future<bool> persistDeviceUUIDInfo(final String userId, final String value);
  Future<bool> removeDeviceUUIDInfo(final String userId);

  Future<DeviceInfoAppDto?> readDeviceInfo(final String userId);
  Future<bool> persistDeviceInfo(final String userId, final DeviceInfoAppDto value);
  Future<bool> removeDeviceInfo(final String userId);

  Future<String?> readSwingInfo(final String userId);
  Future<bool> persistSwingInfo(final String userId, final String value);
  Future<bool> removeSwingInfo(final String userId);
}
