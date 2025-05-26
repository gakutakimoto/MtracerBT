import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mtracersdkexample/view/app/app_root.dart';
import 'package:mtracersdkexample/view/basis/basis_root.dart';
import 'package:mtracersdkexample/view/manualconnect/manualconnect_root.dart';
import 'package:mtracersdkexample/view/panic/panic_root.dart';
import 'package:mtracersdkexample/view/splash/splash_root.dart';
import 'package:mtracersdkexample/viewmodel/main_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  return runApp(const Main());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  late MainViewModel _viewModel;

  _MainState() {
    _viewModel = MainViewModel();
  }

  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // primaryColor: const Color(0xff329123),
      // secondaryHeaderColor: const Color(0xffa8d903),
      // bottomAppBarColor: const Color(0xff252346),
      // highlightColor: const Color(0xfff7951a),
      // scaffoldBackgroundColor: const Color(0xffe8eaeb),
      // locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        locale,
      ],
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        )
      ),
      home: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

          return const SplashRoot();
        },
      ),

      //https://qiita.com/fujit33/items/09dc5bfcd6cab8d6698e
      routes: {
        "/splash": (context) => const SplashRoot(),
      },
      onGenerateRoute: (final RouteSettings settings) {
        switch (settings.name) {
          case "/app":
            return PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) => const AppRoot(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case "/basis":
            return PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) => const BasisRoot(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case "/manualconnect":
            return PageRouteBuilder(
              opaque: true,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) => const ManualConnectRoot(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          default:
            return MaterialPageRoute(builder: (context) => const PanicRoot());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    _viewModel.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _viewModel.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _viewModel.inactive();
    } else if (state == AppLifecycleState.resumed) {
      _viewModel.resumed();
    } else {
      //
    }
  }
}
