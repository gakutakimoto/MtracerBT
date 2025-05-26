import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mtracersdkexample/viewdto/manualconnect/manualconnect_viewdto.dart';
import 'package:mtracersdkexample/viewmodel/manualconnect/manualconnect_viewmodel.dart';

class ManualConnectViewMobilePortrait extends StatefulWidget {
  const ManualConnectViewMobilePortrait({Key? key}) : super(key: key);

  @override
  _ManualConnectViewMobilePortraitState createState() => _ManualConnectViewMobilePortraitState();
}

class _ManualConnectViewMobilePortraitState extends State<ManualConnectViewMobilePortrait> {
  late ManualConnectViewModel _viewModel;

  _ManualConnectViewMobilePortraitState() {
    _viewModel = ManualConnectViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StreamBuilder<ManualConnectViewDto>(
        stream: _viewModel.manualConnectViewVLoC.viewInfo,
        initialData: ManualConnectViewDto(),
        builder: (BuildContext context, AsyncSnapshot<ManualConnectViewDto> viewInfo) {
          var isScanning = false;
          var advertizes = <String>[];

          if (!viewInfo.hasData || viewInfo.data == null) {
          } else {
            //
            isScanning = viewInfo.data!.isScanning;
            advertizes = [...viewInfo.data!.advertizes];
          }

          return Scaffold(
            appBar: AppBar(
              title: const AutoSizeText("手動接続"),
              backgroundColor: const Color(0xff252346),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: _onPressedBackButton,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: isScanning
                ? FloatingActionButton(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    onPressed: _stopScanning,
                    child: const Icon(FontAwesomeIcons.stop),
                  )
                : FloatingActionButton(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    onPressed: _startScan,
                    child: const Icon(FontAwesomeIcons.bluetooth),
                  ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              color: Colors.blueAccent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 64.0,
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              itemCount: advertizes.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _connect(advertizes[index]);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(FontAwesomeIcons.bluetooth),
                      title: Text(advertizes[index]),
                    ),
                  ),
                );
              },
            ),
          );
        },
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

  void _onPressedBackButton() {
    _viewModel.onPressedBackButton(context);
  }

  void _stopScanning() {
    setState(() {
      _viewModel.stopScanning();
    });
  }

  void _startScan() {
    setState(() {
      _viewModel.startScan();
    });
  }

  void _connect(final String localName) {
    _viewModel.connect(localName);
  }
}
