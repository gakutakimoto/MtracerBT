import 'package:flutter/material.dart';
import 'package:mtracersdkexample/viewmodel/app/app_viewmodel.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AppViewMobilePortrait extends StatefulWidget {
  const AppViewMobilePortrait({Key? key}) : super(key: key);

  @override
  _AppViewMobilePortraitState createState() => _AppViewMobilePortraitState();
}

class _AppViewMobilePortraitState extends State<AppViewMobilePortrait> with SingleTickerProviderStateMixin {
  late AppViewModel _viewModel;

  _AppViewMobilePortraitState() {
    _viewModel = AppViewModel();
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
            image: AssetImage("assets/image/app/background.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel.initState();
    WidgetsBinding.instance!.addPostFrameCallback((final Duration timeStamp) {
      _didBuiltView(timeStamp);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _didBuiltView(final Duration timeStamp) {
    _viewModel.didBuiltView(context);
  }
}
