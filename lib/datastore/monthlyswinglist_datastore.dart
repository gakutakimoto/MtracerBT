// import 'package:mtracersdkexample/appdto/swingheaderinfos_appdto.dart';
// import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

// class MonthlySwingHeaderInfosDatastore implements DatastoreInterface<void Function(SwingHeaderInfosAppDto), SwingHeaderInfosAppDto> {
//   static final MonthlySwingHeaderInfosDatastore _instance = MonthlySwingHeaderInfosDatastore._internal();

//   factory MonthlySwingHeaderInfosDatastore() => _instance;

//   late SwingHeaderInfosAppDto _data;
//   late Map<String, void Function(SwingHeaderInfosAppDto)> _subscribers;

//   MonthlySwingHeaderInfosDatastore._internal() {
//     _data = SwingHeaderInfosAppDto();
//     _subscribers = {};
//   }

//   @override
//   SwingHeaderInfosAppDto getData() {
//     return _data;
//   }

//   @override
//   void addSubscriber(final String key, void Function(SwingHeaderInfosAppDto) subscriber) {
//     _subscribers[key] = subscriber;
//   }

//   @override
//   void removeSubscriber(final String key) {
//     _subscribers.remove(key);
//   }

//   @override
//   void publish(final SwingHeaderInfosAppDto value) {
//     _data = value;

//     _subscribers.forEach((key, subscriber) {
//       subscriber(value);
//     });
//   }
// }
