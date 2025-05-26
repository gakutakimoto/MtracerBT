import 'package:mtracersdkexample/appdto/appinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class AppInfoDatastore implements DatastoreInterface<void Function(AppInfoAppDto), AppInfoAppDto> {
  static final AppInfoDatastore _instance = AppInfoDatastore._internal();
  factory AppInfoDatastore() => _instance;

  late AppInfoAppDto _data;
  late Map<String, void Function(AppInfoAppDto)> _subscribers;

  AppInfoDatastore._internal() {
    _data = AppInfoAppDto();
    _subscribers = {};
  }

  @override
  AppInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(AppInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final AppInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
