import "package:flutter/material.dart";
import 'package:mtracersdkexample/view/panic/panic_view_mobileportrait.dart';

class PanicRoot extends StatefulWidget {
  const PanicRoot({Key? key}) : super(key: key);

  @override
  _PanicRootState createState() => _PanicRootState();
}

class _PanicRootState extends State<PanicRoot> {
  @override
  Widget build(BuildContext context) {
    return const PanicViewMobilePortrait();
  }
}
