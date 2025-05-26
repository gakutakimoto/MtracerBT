import 'package:mtracersdkexample/appdto/newsinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class NewsInfoDatastore implements DatastoreInterface<void Function(List<NewsInfoAppDto>), List<NewsInfoAppDto>> {
  static final NewsInfoDatastore _instance = NewsInfoDatastore._internal();
  factory NewsInfoDatastore() => _instance;

  late List<NewsInfoAppDto> _data;
  late Map<String, void Function(List<NewsInfoAppDto>)> _subscribers;

  NewsInfoDatastore._internal() {
    _data = [];
    _subscribers = {};
  }

  @override
  List<NewsInfoAppDto> getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(List<NewsInfoAppDto>) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final List<NewsInfoAppDto> value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
