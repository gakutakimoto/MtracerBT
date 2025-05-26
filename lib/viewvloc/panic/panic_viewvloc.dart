import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';
import 'package:mtracersdkexample/viewdto/panic/panic_viewdto.dart';
import 'package:rxdart/rxdart.dart';

class PanicViewVLoC {
  static final PanicViewVLoC _instance = PanicViewVLoC._internal();
  factory PanicViewVLoC() => _instance;

  //ViewInfo
  late PanicViewDto _viewInfoStore;

  //Datastore
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> _userInfoDatastore;

  //ViewInfoStream
  final _viewInfo = BehaviorSubject<PanicViewDto>.seeded(PanicViewDto());
  Stream<PanicViewDto> get viewInfo => _viewInfo;

  PanicViewVLoC._internal() {
    //ViewInfo
    _viewInfoStore = PanicViewDto();

    //Datastore
    //UserInfoDatastore
    _userInfoDatastore = UserInfoDatastore();
    _userInfoDatastore.addSubscriber(toString(), (final UserInfoAppDto value) {
      _onReceiveUserInfo(value);
    });
    _setUserInfo(_userInfoDatastore.getData());

    _viewInfo.add(_viewInfoStore);
  }

  void dispose() {
    //Datastore
    _userInfoDatastore.removeSubscriber(toString());

    //ViewInfoStream
    _viewInfo.close();
  }

  void _onReceiveUserInfo(final UserInfoAppDto value) {
    _setUserInfo(value);
    _viewInfo.add(_viewInfoStore);
  }

  void _setUserInfo(final UserInfoAppDto value) {
    _viewInfoStore.nickName = value.userBasicProfileInfo.nickName;
    _viewInfoStore.userId = value.userId;
  }
}
