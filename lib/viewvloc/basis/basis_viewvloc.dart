import 'package:mtracersdkexample/appdto/deviceinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/deviceinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/viewdto/basis/bsis_viewdto.dart';
import 'package:rxdart/rxdart.dart';

class BasisViewVLoC {
  static final BasisViewVLoC _instance = BasisViewVLoC._internal();
  factory BasisViewVLoC() => _instance;

  //ViewInfo
  late BasisViewDto _viewInfoStore;

  //Datastore
  late DatastoreInterface<void Function(DeviceInfoAppDto), DeviceInfoAppDto> _deviceInfoDatastore;

  //ViewInfoStream
  final _viewInfo = BehaviorSubject<BasisViewDto>.seeded(BasisViewDto());
  Stream<BasisViewDto> get viewInfo => _viewInfo;
  final _initViewInfo = PublishSubject<BasisViewDto>();
  Sink<BasisViewDto> get initViewInfo => _initViewInfo.sink;

  BasisViewVLoC._internal() {
    //ViewInfo
    _viewInfoStore = BasisViewDto();

    // //Datastore
    //DeviceInfoDatastore
    _deviceInfoDatastore = DeviceInfoDatastore();
    _deviceInfoDatastore.addSubscriber(toString(), (final DeviceInfoAppDto value) {
      _onReceiveDeviceInfo(value);
    });
    _setDeviceInfo(_deviceInfoDatastore.getData());

    _viewInfo.add(_viewInfoStore);
  }

  void dispose() {
    //Datastore
    _deviceInfoDatastore.removeSubscriber(toString());

    //ViewInfoStream
    _viewInfo.close();
    _initViewInfo.close();
  }

  void _onReceiveDeviceInfo(final DeviceInfoAppDto value) {
    _setDeviceInfo(value);
    _viewInfo.add(_viewInfoStore);
  }

  void _setDeviceInfo(final DeviceInfoAppDto value) {
    _viewInfoStore.batteryLevel = value.batteryLevel;
  }
}
