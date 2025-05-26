import 'package:mtracersdkexample/appdto/userpointinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class PointInfoDatastore implements DatastoreInterface<void Function(UserPointInfoAppDto), UserPointInfoAppDto> {
  static final PointInfoDatastore _instance = PointInfoDatastore._internal();

  factory PointInfoDatastore() => _instance;

  late UserPointInfoAppDto _data;
  late Map<String, void Function(UserPointInfoAppDto)> _subscribers;

  PointInfoDatastore._internal() {
    _data = UserPointInfoAppDto();
    _subscribers = {};
  }

  @override
  UserPointInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(UserPointInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final UserPointInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
