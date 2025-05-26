import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class AdvertizeInfoDatastore implements DatastoreInterface<void Function(List<String>), List<String>> {
  static final AdvertizeInfoDatastore _instance = AdvertizeInfoDatastore._internal();
  factory AdvertizeInfoDatastore() => _instance;

  late List<String> _data;
  late Map<String, void Function(List<String>)> _subscribers;

  AdvertizeInfoDatastore._internal() {
    _data = [];
    _subscribers = {};
  }

  @override
  List<String> getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(List<String>) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final List<String> value) {
    _data = [...value];

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
