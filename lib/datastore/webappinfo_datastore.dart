import 'package:mtracersdkexample/appdto/webappinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class WebAppInfoDatastore implements DatastoreInterface<void Function(WebAppInfoAppDto), WebAppInfoAppDto> {
  static final WebAppInfoDatastore _instance = WebAppInfoDatastore._internal();

  factory WebAppInfoDatastore() => _instance;

  late WebAppInfoAppDto _data;
  late Map<String, void Function(WebAppInfoAppDto)> _subscribers;

  WebAppInfoDatastore._internal() {
    _data = WebAppInfoAppDto();
    _subscribers = {};
  }

  @override
  WebAppInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(WebAppInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final WebAppInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
