import "package:flutter/material.dart";
import 'package:mtracersdkexample/view/manualconnect/manualconnect_view_mobileportrait.dart';

class ManualConnectRoot extends StatefulWidget {
  const ManualConnectRoot({Key? key}) : super(key: key);

  @override
  _ManualConnectRootState createState() => _ManualConnectRootState();
}

class _ManualConnectRootState extends State<ManualConnectRoot> {
  @override
  Widget build(BuildContext context) {
    return const ManualConnectViewMobilePortrait();
  }
}
