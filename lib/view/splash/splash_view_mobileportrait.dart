import 'package:flutter/material.dart';
import 'package:mtracersdkexample/viewmodel/splash/splash_viewmodel.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SplashViewMobilePortrait extends StatefulWidget {
  const SplashViewMobilePortrait({Key? key}) : super(key: key);

  @override
  _SplashViewMobilePortraitState createState() => _SplashViewMobilePortraitState();
}

class _SplashViewMobilePortraitState extends State<SplashViewMobilePortrait> {
  late SplashViewModel _viewModel;

  _SplashViewMobilePortraitState() {
    _viewModel = SplashViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Shimmer(
        duration: const Duration(milliseconds: 2000),
        color: Colors.white,
        colorOpacity: 0.3,
        enabled: true,
        direction: const ShimmerDirection.fromLTRB(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Image(
            image: AssetImage("assets/image/splash/background.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    _viewModel.initState();
    WidgetsBinding.instance!.addPostFrameCallback((final Duration timeStamp) {
      _didBuiltView(timeStamp);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _didBuiltView(final Duration timeStamp) {
    _viewModel.didBuiltView(context);
  }
}
