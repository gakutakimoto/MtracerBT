import "package:flutter/material.dart";
import 'package:mtracersdkexample/view/app/app_view_mobileportrait.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return const AppViewMobilePortrait();
  }
}
