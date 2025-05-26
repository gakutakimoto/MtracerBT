import 'package:mtracersdkexample/appdto/reportclubinfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class ReportClubInfoDatastore implements DatastoreInterface<void Function(ReportClubInfoAppDto), ReportClubInfoAppDto> {
  static final ReportClubInfoDatastore _instance = ReportClubInfoDatastore._internal();
  factory ReportClubInfoDatastore() => _instance;

  late ReportClubInfoAppDto _data;
  late Map<String, void Function(ReportClubInfoAppDto)> _subscribers;

  ReportClubInfoDatastore._internal() {
    _data = ReportClubInfoAppDto();
    _subscribers = {};
  }

  @override
  ReportClubInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(ReportClubInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final ReportClubInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
