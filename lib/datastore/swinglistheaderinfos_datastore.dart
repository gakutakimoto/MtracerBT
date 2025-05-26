import 'package:mtracersdkexample/appdto/swinglistheaderinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class SwingListHeaderInfosDatastore implements DatastoreInterface<void Function(Map<String, List<SwingListHeaderInfoAppDto>>), Map<String, List<SwingListHeaderInfoAppDto>>> {
  static final SwingListHeaderInfosDatastore _instance = SwingListHeaderInfosDatastore._internal();

  factory SwingListHeaderInfosDatastore() => _instance;

  late Map<String, List<SwingListHeaderInfoAppDto>> _data;
  late Map<String, void Function(Map<String, List<SwingListHeaderInfoAppDto>>)> _subscribers;

  SwingListHeaderInfosDatastore._internal() {
    _data = <String, List<SwingListHeaderInfoAppDto>>{};
    _subscribers = {};
  }

  @override
  Map<String, List<SwingListHeaderInfoAppDto>> getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(Map<String, List<SwingListHeaderInfoAppDto>>) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final Map<String, List<SwingListHeaderInfoAppDto>> value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(value);
    });
  }
}
