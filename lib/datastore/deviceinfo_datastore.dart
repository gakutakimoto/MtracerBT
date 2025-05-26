import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class DeviceInfoDatastore implements DatastoreInterface<void Function(DeviceInfoAppDto), DeviceInfoAppDto> {
  static final DeviceInfoDatastore _instance = DeviceInfoDatastore._internal();
  factory DeviceInfoDatastore() => _instance;

  late DeviceInfoAppDto _data;
  late Map<String, void Function(DeviceInfoAppDto)> _subscribers;

  DeviceInfoDatastore._internal() {
    _data = DeviceInfoAppDto();
    _subscribers = {};
  }

  @override
  DeviceInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(DeviceInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final DeviceInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
