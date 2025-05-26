import 'package:mtracersdkexample/appdto/webpageinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class WebPageInfoDatastore implements DatastoreInterface<void Function(WebPageInfoAppDto), WebPageInfoAppDto> {
  static final WebPageInfoDatastore _instance = WebPageInfoDatastore._internal();

  factory WebPageInfoDatastore() => _instance;

  late WebPageInfoAppDto _data;
  late Map<String, void Function(WebPageInfoAppDto)> _subscribers;

  WebPageInfoDatastore._internal() {
    _data = WebPageInfoAppDto();
    _subscribers = {};
  }

  @override
  WebPageInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(WebPageInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final WebPageInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
