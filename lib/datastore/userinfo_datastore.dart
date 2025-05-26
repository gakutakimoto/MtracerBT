import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class UserInfoDatastore implements DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> {
  static final UserInfoDatastore _instance = UserInfoDatastore._internal();
  factory UserInfoDatastore() => _instance;

  late UserInfoAppDto _data;
  late Map<String, void Function(UserInfoAppDto)> _subscribers;

  UserInfoDatastore._internal() {
    _data = UserInfoAppDto();
    _subscribers = {};
  }

  @override
  UserInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(UserInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final UserInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
