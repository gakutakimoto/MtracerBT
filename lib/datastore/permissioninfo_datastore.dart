import 'package:mtracersdkexample/appdto/permissioninfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class PermissionInfoDatastore implements DatastoreInterface<void Function(PermissionInfoAppDto), PermissionInfoAppDto> {
  static final PermissionInfoDatastore _instance = PermissionInfoDatastore._internal();
  factory PermissionInfoDatastore() => _instance;

  late PermissionInfoAppDto _data;
  late Map<String, void Function(PermissionInfoAppDto)> _subscribers;

  PermissionInfoDatastore._internal() {
    _data = PermissionInfoAppDto();
    _subscribers = {};
  }

  @override
  PermissionInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(PermissionInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final PermissionInfoAppDto value) {
    _data.camera = value.camera;
    _data.photos = value.photos;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
