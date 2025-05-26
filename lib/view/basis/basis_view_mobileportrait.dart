import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtracersdkexample/appdto/swinginfo_appdto.dart';
import 'package:mtracersdkexample/view/basis/card_view.dart';
import 'package:mtracersdkexample/viewdto/basis/bsis_viewdto.dart';
import 'package:mtracersdkexample/viewmodel/basis/basis_viewmodel.dart';

class BasisViewMobilePortrait extends StatefulWidget {
  const BasisViewMobilePortrait({Key? key}) : super(key: key);

  @override
  _BasisViewMobilePortraitState createState() => _BasisViewMobilePortraitState();
}

class _BasisViewMobilePortraitState extends State<BasisViewMobilePortrait> {
  late BasisViewModel _viewModel;
  late int _swingCount;
  late double _hs;
  late double _angle1;
  late double _angle2;
  late double _angle3;
  late String _selectedAddressFaceAngleType;
  late List<String> _addressFaceAngleType;

  _BasisViewMobilePortraitState() {
    _viewModel = BasisViewModel();
    _swingCount = 0;
    _hs = 0.0;
    _angle1 = 0.0;
    _angle2 = 0.0;
    _angle3 = 0.0;
    _selectedAddressFaceAngleType = "Square";
    _addressFaceAngleType = ["Open(High)", "Open(Mid)", "Open(Low)", "Square", "Close(Low)", "Close(Mid)", "Close(High)"];
  }

  @override
  void dispose() {
    // if (_viewModel.receiveImpactEvent != null) {
    //   _viewModel.receiveImpactEvent!.cancel();
    //   _viewModel.receiveImpactEvent = null;
    // }

    // if (_viewModel.receiveSwingInfoEvent != null) {
    //   _viewModel.receiveSwingInfoEvent!.cancel();
    //   _viewModel.receiveSwingInfoEvent = null;
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BasisViewDto>(
      stream: _viewModel.basisViewVLoC.viewInfo,
      initialData: BasisViewDto(),
      builder: (BuildContext context, AsyncSnapshot<BasisViewDto> viewInfo) {
        var batteryLevel = 0;
        var isReceiveImpact = false;
        var isReceiveSwingInfo = false;
        var index = 0;
        var impactHeadSpeed = 0.0;

        if (!viewInfo.hasData || viewInfo.data == null) {
        } else {
          batteryLevel = viewInfo.data!.batteryLevel;
          isReceiveImpact = viewInfo.data!.isReceiveImpact;
          isReceiveSwingInfo = viewInfo.data!.isReceiveSwingInfo;
          index = viewInfo.data!.index;
          impactHeadSpeed = viewInfo.data!.impactHeadSpeed;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "M-Tracer SDK",
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            // actions: (_viewModel.receiveSwingInfoEvent != null)
            //     ? null
            //     : <Widget>[
            //         PopupMenuButton<String>(
            //           onSelected: (String s) {
            //             _viewModel.setAddressFaceAngleType(s);
            //             setState(() {
            //               _selectedAddressFaceAngleType = s;
            //             });
            //           },
            //           itemBuilder: (BuildContext context) {
            //             return _addressFaceAngleType.map((String s) {
            //               return PopupMenuItem(
            //                 child: Text(
            //                   ((s == _selectedAddressFaceAngleType) ? "[X] " : "    ") + s,
            //                   style: TextStyle(color: (s == _selectedAddressFaceAngleType) ? Colors.red : Colors.black),
            //                 ),
            //                 value: s,
            //               );
            //             }).toList();
            //           },
            //         ),
            //       ],
          ),
          body: SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 24,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              // children: [
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7, child: null,),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 7),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 8),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 8),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 8),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 8),
              // StaggeredGridTile.count(crossAxisCellCount: 24, mainAxisCellCount: 15),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 6),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 6),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 6),
              // StaggeredGridTile.count(crossAxisCellCount: 6, mainAxisCellCount: 6),
              // ],
              children: [
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       Icons.bluetooth,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.blue,
                //     "接続",
                //     13.0,
                //     _pushConnectView,
                //   ),
                // ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      Icons.bluetooth,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.blue,
                    "手動接続",
                    13.0,
                    _pushManualConnectView,
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      Icons.link_off,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.redAccent,
                    "切断",
                    13.0,
                    _disconnect,
                  ),
                ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.leaf,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.green,
                //     "BLE停止",
                //     13.0,
                //     _switchToBLEEcoMode,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       Icons.book,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.green,
                //     "接続予約",
                //     13.0,
                //     _pushBookConnectView,
                //   ),
                // ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      FontAwesomeIcons.batteryFull,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.amber,
                    "電池残量",
                    13.0,
                    _readBatteryLevel,
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      FontAwesomeIcons.batteryFull,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.amber,
                    batteryLevel.toString() + "%",
                    13.0,
                    () {},
                  ),
                ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.microchip,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.purpleAccent,
                //     "製品情報",
                //     13.0,
                //     _pushProductView,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.microchip,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.cyan,
                //     "HW情報",
                //     13.0,
                //     _pushHWView,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.industry,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.red,
                //     "初期化",
                //     13.0,
                //     _resetToFactorySetting,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.microchip,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.deepPurple,
                //     "FW情報\nFW更新",
                //     13.0,
                //     _pushFWView,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       Icons.settings,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.pinkAccent,
                //     "機器設定",
                //     13.0,
                //     _pushPreferenceView,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.golfBall,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.lightBlueAccent,
                //     "Swing\n情報",
                //     13.0,
                //     _pushSwingInfoView,
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 8,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.adjust,
                //       size: 29.0,
                //       color: Colors.white,
                //     ),
                //     Colors.teal,
                //     "機器校正",
                //     13.0,
                //     _calibrate,
                //   ),
                // ),
                StaggeredGridTile.count(
                    crossAxisCellCount: 6,
                    mainAxisCellCount: 7,
                    child: CardView(
                      Icon(
                        (isReceiveImpact) ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                        size: 29.0,
                        color: Colors.white,
                      ),
                      Colors.orangeAccent,
                      "監視\nImpact",
                      13.0,
                      _receiveImpactEvent,
                    )),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    Icon(
                      (isReceiveSwingInfo) ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.orangeAccent,
                    "監視\nSwing",
                    13.0,
                    _toggleReceiveSwingInfoEvent,
                  ),
                ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 8,
                //   child: StreamBuilder<NotificationInfoDto>(
                //       stream: _viewModel.notificationInfoBLoC.value,
                //       builder: (final BuildContext context,
                //           final AsyncSnapshot<NotificationInfoDto> snapshot) {
                //         if (!snapshot.hasData) {
                //           return Container(
                //             height: 0.0,
                //             width: 0.0,
                //           );
                //         }

                //         return CardView(
                //           Icon(
                //             snapshot.data!.swingInfoEvent
                //                 ? FontAwesomeIcons.eye
                //                 : FontAwesomeIcons.eyeSlash,
                //             size: 29.0,
                //             color: Colors.white,
                //           ),
                //           Colors.orangeAccent,
                //           "監視\nSwing情報+削除",
                //           13.0,
                //           _toggle70SecLoopEvent,
                //         );
                //       }),
                // ),
                // Container(
                //   color: Colors.blue,
                //   child: SizedBox(
                //       height: 640,
                //       width: 320,
                //       child: UiKitView(viewType: "ramdom_noise")),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 24,
                //   mainAxisCellCount: 15,
                //   child: CardView(
                //     Icon(
                //       FontAwesomeIcons.golfBall,
                //       size: 60.0,
                //       color: Colors.white,
                //     ),
                //     Colors.deepOrangeAccent,
                //     _swingCount.toString(),
                //     100.0,
                //     () {},
                //   ),
                // ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      Icons.speed,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.orangeAccent,
                    "Index\n" + index.toString(),
                    16.0,
                    _toggleReceiveSwingInfoEvent,
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 6,
                  mainAxisCellCount: 7,
                  child: CardView(
                    const Icon(
                      Icons.speed,
                      size: 29.0,
                      color: Colors.white,
                    ),
                    Colors.orangeAccent,
                    "HS\n" + impactHeadSpeed.toStringAsFixed(1),
                    16.0,
                    _toggleReceiveSwingInfoEvent,
                  ),
                ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     const Icon(Icons.abc),
                //     Colors.deepOrangeAccent,
                //     "Face\n" + _angle1.toString(),
                //     16.0,
                //     () {},
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     const Icon(Icons.abc),
                //     Colors.deepOrangeAccent,
                //     "Path\n" + _angle2.toString(),
                //     16.0,
                //     () {},
                //   ),
                // ),
                // StaggeredGridTile.count(
                //   crossAxisCellCount: 6,
                //   mainAxisCellCount: 7,
                //   child: CardView(
                //     const Icon(Icons.abc),
                //     Colors.deepOrangeAccent,
                //     "Attack\n" + _angle3.toString(),
                //     16.0,
                //     () {},
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pushConnectView() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return ConnectRootView();
    //     },
    //   ),
    // );
  }

  void _pushManualConnectView() {
    Navigator.of(context).pushReplacementNamed("/manualconnect");
  }

  void _switchToBLEEcoMode() {
    // _viewModel.switchToBLEEcoMode().then((_) {
    //   Fluttertoast.showToast(
    //     msg: "設定完了",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }).catchError((error) {
    //   Fluttertoast.showToast(
    //     msg: error.toString(),
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // });
  }

  void _pushBookConnectView() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return BookConnectRootView();
    //     },
    //   ),
    // );
  }

  void _readBatteryLevel() {
    _viewModel.readBatteryLevel();
  }

  void _disconnect() {
    _viewModel.disconnect();
  }

  // void _pushPreferenceView() {
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) {
  //       return PreferenceRootView();
  //     },
  //   ),
  // );
  // }

  // void _resetToFactorySetting() {
  // _viewModel.resetToFactorySetting().then((_) {
  //   Fluttertoast.showToast(
  //     msg: "初期化完了",
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER,
  //     // timeInSecForIos: 1,
  //     backgroundColor: Colors.blue,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }).catchError((error) {
  //   Fluttertoast.showToast(
  //     msg: error.toString(),
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER,
  //     // timeInSecForIos: 1,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // });
  // }

  // void _pushHWView() {
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) {
  //       return HWRootView();
  //     },
  //   ),
  // );
  // }

  // void _pushProductView() {
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) {
  //       return ProductRootView();
  //     },
  //   ),
  // );
  // }

  // void _pushFWView() {
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) {
  //       return FWRootView();
  //     },
  //   ),
  // );
  // }

  // void _pushSwingInfoView() {
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) {
  //       return SwingRootView();
  //     },
  //   ),
  // );
  // }

  // void _calibrate() {
  // _viewModel.calibrate().then((_) {
  //   Fluttertoast.showToast(
  //     msg: "校正完了",
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER,
  //     // timeInSecForIos: 1,
  //     backgroundColor: Colors.blue,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }).catchError((error) {
  //   Fluttertoast.showToast(
  //     msg: error.toString(),
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER,
  //     // timeInSecForIos: 1,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // });
  // }

  void _receiveImpactEvent() {
    setState(() {
      _viewModel.receiveImpactEvent(() {
        setState(() {
          //
        });
      });
    });
  }

  void _toggleReceiveSwingInfoEvent() {
    setState(() {
      _viewModel.receiveSwingInfoEvent(() {
        setState(() {
          //
        });
      }, () {
        setState(() {
          //
        });
      });
    });

    // _viewModel.toggleReceiveSwingInfoEvent((response) {
    //   Fluttertoast.showToast(
    //     msg: "Swing情報発生:" + response["impactId"] + "/" + response["index"].toString(),
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );

    //   setState(() {
    //     _swingCount += 1;
    //     _hs = (response["hs"] as num) * 1.0;
    //     _angle1 = (response["angle1"] as num) * 1.0;
    //     _angle2 = (response["angle2"] as num) * 1.0;
    //     _angle3 = (response["angle3"] as num) * 1.0;
    //   });
    // }, () {
    //   setState(() {});

    //   Fluttertoast.showToast(
    //     msg: "Swing情報監視開始",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }, () {
    //   setState(() {});
    // }, (error) {
    //   Fluttertoast.showToast(
    //     msg: error.toString(),
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // });
  }

  void _toggle70SecLoopEvent() {
    // _viewModel.toggle70SecLoopEvent((response) {
    //   Fluttertoast.showToast(
    //     msg: "70Sec監視発生:" + response["impactId"] + "/" + response["index"].toString(),
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );

    //   setState(() {
    //     _swingCount += 1;
    //     _hs = (response["hs"] as num) * 1.0;
    //     _angle1 = (response["angle1"] as num) * 1.0;
    //     _angle2 = (response["angle2"] as num) * 1.0;
    //     _angle3 = (response["angle3"] as num) * 1.0;
    //   });
    // }, () {
    //   Fluttertoast.showToast(
    //     msg: "70Sec監視開始",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.blue,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }, (error) {
    //   Fluttertoast.showToast(
    //     msg: error.toString(),
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     // timeInSecForIos: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // });
  }
}
