import 'package:mtracersdkexample/appdto/userlessoninfo_appdto.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class LessonInfoDatastore implements DatastoreInterface<void Function(UserLessonInfoAppDto), UserLessonInfoAppDto> {
  static final LessonInfoDatastore _instance = LessonInfoDatastore._internal();

  factory LessonInfoDatastore() => _instance;

  late UserLessonInfoAppDto _data;
  late Map<String, void Function(UserLessonInfoAppDto)> _subscribers;

  LessonInfoDatastore._internal() {
    _data = UserLessonInfoAppDto();
    _subscribers = {};
  }

  @override
  UserLessonInfoAppDto getData() {
    return _data;
  }

  @override
  void addSubscriber(final String key, void Function(UserLessonInfoAppDto) subscriber) {
    _subscribers[key] = subscriber;
  }

  @override
  void removeSubscriber(final String key) {
    _subscribers.remove(key);
  }

  @override
  void publish(final UserLessonInfoAppDto value) {
    _data = value;

    _subscribers.forEach((key, subscriber) {
      subscriber(_data);
    });
  }
}
