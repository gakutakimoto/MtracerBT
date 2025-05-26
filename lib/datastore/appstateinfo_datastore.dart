import 'package:mtracersdkexample/appdto/appstateinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class AppStateInfoDatastore implements DatastoreInterface<void Function(AppStateInfoAppDto), AppStateInfoAppDto> {
  static final AppStateInfoDatastore _instance = AppStateInfoDatastore._internal();
  factory AppStateInfoDatastore() => _instance;

  late AppStateInfoAppDto _data;
  late Map<String, void Function(AppStateInfoAppDto)> _subscribers;

  AppStateInfoDatastore._internal() {
    _data = AppStateInfoAppDto();
    _subscribers = {};
  }

  @override
  AppStateInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(AppStateInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final AppStateInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
