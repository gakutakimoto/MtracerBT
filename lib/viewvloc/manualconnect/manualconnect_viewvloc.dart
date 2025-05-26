import 'package:mtracersdkexample/datastore/advertizeinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/viewdto/manualconnect/manualconnect_viewdto.dart';
import 'package:rxdart/rxdart.dart';

class ManualConnectViewVLoC {
  static final ManualConnectViewVLoC _instance = ManualConnectViewVLoC._internal();
  factory ManualConnectViewVLoC() => _instance;

  //ViewInfo
  late ManualConnectViewDto _viewInfoStore;

  //Datastore
  late DatastoreInterface<void Function(List<String>), List<String>> _advertizeInfoDatastore;

  //ViewInfoStream
  final _viewInfo = BehaviorSubject<ManualConnectViewDto>.seeded(ManualConnectViewDto());
  Stream<ManualConnectViewDto> get viewInfo => _viewInfo;
  final _initViewInfo = PublishSubject<ManualConnectViewDto>();
  Sink<ManualConnectViewDto> get initViewInfo => _initViewInfo.sink;

  ManualConnectViewVLoC._internal() {
    //ViewInfo
    _viewInfoStore = ManualConnectViewDto();

    // //Datastore
    //AdvertizeInfoDatastore
    _advertizeInfoDatastore = AdvertizeInfoDatastore();
    _advertizeInfoDatastore.addSubscriber(toString(), (final List<String> value) {
      _onReceiveAdvertizeInfo(value);
    });
    _setAdvertizeInfo(_advertizeInfoDatastore.getData());

    _viewInfo.add(_viewInfoStore);
  }

  void dispose() {
    //Datastore
    _advertizeInfoDatastore.removeSubscriber(toString());

    //ViewInfoStream
    _viewInfo.close();
    _initViewInfo.close();
  }

  void _onReceiveAdvertizeInfo(final List<String> value) {
    _setAdvertizeInfo(value);
    _viewInfo.add(_viewInfoStore);
  }

  void _setAdvertizeInfo(final List<String> value) {
    _viewInfoStore.advertizes = [...value];
  }
}
