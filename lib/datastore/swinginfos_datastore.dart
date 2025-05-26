import 'package:mtracersdkexample/appdto/swinginfos_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class SwingInfosDatastore implements DatastoreInterface<void Function(SwingInfosAppDto), SwingInfosAppDto> {
  static final SwingInfosDatastore _instance = SwingInfosDatastore._internal();
  factory SwingInfosDatastore() => _instance;

  late SwingInfosAppDto _data;
  late Map<String, void Function(SwingInfosAppDto)> _subscribers;

  SwingInfosDatastore._internal() {
    _data = SwingInfosAppDto();
    _subscribers = {};
  }

  @override
  SwingInfosAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(SwingInfosAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final SwingInfosAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
