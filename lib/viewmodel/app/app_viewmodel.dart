import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtracersdkexample/appdto/gender_type.dart';
import 'package:mtracersdkexample/appdto/userinfo_appdto.dart';
import 'package:mtracersdkexample/datastore/userinfo_datastore.dart';
import 'package:mtracersdkexample/datastoreinterface/datastoreinterface.dart';

class AppViewModel {
  late DatastoreInterface<void Function(UserInfoAppDto), UserInfoAppDto> userInfoDatastore;

  AppViewModel() {
    userInfoDatastore = UserInfoDatastore();
  }

  void initState() {}

  void dispose() {}

  Future<void> didBuiltView(final BuildContext context) async {
    final userInfo = userInfoDatastore.getData();
    userInfo.userId = "7f91458c26384f46b1606812cc253f48";
    userInfo.userBasicProfileInfo.height = 173.5;
    userInfo.userBasicProfileInfo.genderType = GenderType.male;
    userInfo.userBasicProfileInfo.birthday = DateTime(2000, 1, 2);
    userInfo.userGolferProfileInfo.scoreAVG = 100;

    Navigator.of(context).pushReplacementNamed("/basis");
  }
}
