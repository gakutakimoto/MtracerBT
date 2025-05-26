import 'package:mtracersdkexample/appdto/cloudendpointinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class CloudEndpointInfoDatastore implements DatastoreInterface<void Function(CloudEndpointInfoAppDto), CloudEndpointInfoAppDto> {
  static final CloudEndpointInfoDatastore _instance = CloudEndpointInfoDatastore._internal();
  factory CloudEndpointInfoDatastore() => _instance;

  late CloudEndpointInfoAppDto _data;
  late Map<String, void Function(CloudEndpointInfoAppDto)> _subscribers;

  CloudEndpointInfoDatastore._internal() {
    _data = CloudEndpointInfoAppDto();
    _subscribers = {};
  }

  @override
  CloudEndpointInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(CloudEndpointInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final CloudEndpointInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
