import 'package:mtracersdkexample/appdto/licenseinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class LicenseInfoDatastore implements DatastoreInterface<void Function(List<LicenseInfoAppDto>), List<LicenseInfoAppDto>> {
  static final LicenseInfoDatastore _instance = LicenseInfoDatastore._internal();
  factory LicenseInfoDatastore() => _instance;

  late List<LicenseInfoAppDto> _data;
  late Map<String, void Function(List<LicenseInfoAppDto>)> _subscribers;

  LicenseInfoDatastore._internal() {
    _data = [];
    _subscribers = {};
  }

  @override
  List<LicenseInfoAppDto> getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(List<LicenseInfoAppDto>) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final List<LicenseInfoAppDto> value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
