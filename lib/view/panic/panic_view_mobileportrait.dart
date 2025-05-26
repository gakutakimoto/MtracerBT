import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mtracersdkexample/viewmodel/panic/panic_viewmodel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PanicViewMobilePortrait extends StatefulWidget {
  const PanicViewMobilePortrait({Key? key}) : super(key: key);

  @override
  _PanicViewMobilePortraitState createState() => _PanicViewMobilePortraitState();
}

class _PanicViewMobilePortraitState extends State<PanicViewMobilePortrait> {
  late PanicViewModel _panicViewModel;

  _PanicViewMobilePortraitState() {
    _panicViewModel = PanicViewModel();
  }

  @override
  Widget build(final BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (Platform.isAndroid) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          headerAnimationLoop: true,
          title: 'エラー',
          body: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                const AutoSizeText(
                  "予期せぬエラーが発生しました。\nエムトレGolfを再起動をしてください。",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const AutoSizeText(
                        "再起動する",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _onPressedReStart,
                    ),
                  ),
                ),
                const AutoSizeText(
                  "数回エムトレGolfを再起動をしてもエラーが発生する場合は、下記よりお問合せメールを送信してください。",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const AutoSizeText(
                        "エムトレGolf お問合せ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _onPressedContact,
                    ),
                  ),
                ),
              ],
            ),
          ),
          dismissOnTouchOutside: false,
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          headerAnimationLoop: true,
          animType: AnimType.topSlide,
          title: 'エラー',
          body: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                const AutoSizeText(
                  "予期せぬエラーが発生しました。\nエムトレGolfを再起動をしてください。",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 3,
                ),
                const AutoSizeText(
                  "数回エムトレGolfを再起動をしてもエラーが発生する場合は、下記よりお問合せメールを送信してください。",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const AutoSizeText(
                        "エムトレGolf お問合せ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _onPressedContact,
                    ),
                  ),
                ),
              ],
            ),
          ),
          dismissOnTouchOutside: false,
        ).show();
      }
    });
    return const Image(
      image: AssetImage('assets/image/panic/background.png'),
      fit: BoxFit.cover,
    );
  }

  void _onPressedReStart() {
    _panicViewModel.onPressedReStart();
  }

  void _onPressedContact() {
    _panicViewModel.onPressedContact(context);
  }
}
