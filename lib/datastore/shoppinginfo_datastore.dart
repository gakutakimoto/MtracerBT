import 'package:mtracersdkexample/appdto/shoppinginfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class ShoppingInfoDatastore implements DatastoreInterface<void Function(ShoppingInfoAppDto), ShoppingInfoAppDto> {
  static final ShoppingInfoDatastore _instance = ShoppingInfoDatastore._internal();
  factory ShoppingInfoDatastore() => _instance;

  late ShoppingInfoAppDto _data;
  late Map<String, void Function(ShoppingInfoAppDto)> _subscribers;

  ShoppingInfoDatastore._internal() {
    _data = ShoppingInfoAppDto();
    _subscribers = {};
  }

  @override
  ShoppingInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(ShoppingInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final ShoppingInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
