import 'package:flutter/material.dart';
import 'package:mtracersdkexample/view/splash/splash_view_mobileportrait.dart';

class SplashRoot extends StatefulWidget {
  const SplashRoot({Key? key}) : super(key: key);

  @override
  _SplashRootState createState() => _SplashRootState();
}

class _SplashRootState extends State<SplashRoot> {
  @override
  Widget build(BuildContext context) {
    return const SplashViewMobilePortrait();
  }
}
