import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sams/screens/maintenance/maintenance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/prefs.dart';
import 'screens/maintenance/force_update.dart';
import 'screens/maintenance/offline.dart';
import 'screens/onboarding/login.dart';
import 'screens/onboarding/splash.dart';
import 'services/api.dart';

SharedPreferanceKeyString prefKey = SharedPreferanceKeyString();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SeldomApp extends StatefulWidget {
  final bool isNetworkConnect;
  const SeldomApp({super.key, required this.isNetworkConnect});

  @override
  State<SeldomApp> createState() => _SeldomAppState();
}

class _SeldomAppState extends State<SeldomApp> {
  bool isSplash = false;
  bool appMaintenence = false;
  bool appUpdate = false;
  bool appForceUpdate = false;
  bool isDeviceConnected = false;
  late StreamSubscription subscription;
  ValueNotifier<bool> isNetwork = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    setState(() {
      isNetwork.value = widget.isNetworkConnect;
    });
    isNetwork.addListener(() {
      fetchData(false, context);
    });

    fetchData(true, context);
  }

  fetchData(isFirstView, context) async {
    if (isFirstView) {
      await getConnectivity();
    }
    if (!isFirstView) {
      setState(() {
        isSplash = true;
        appMaintenence = false;
        appUpdate = false;
        appForceUpdate = false;
      });
    }
    _checkApp(context);
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult> result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected) {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => const OfflinePage()),
            );

            Future.delayed(Duration.zero, () {
              _waitForDeviceConnection();
            });
          } else {
            setState(() {
              isNetwork.value = true;
            });
            // Device is already connected, proceed with your logic
            Navigator.of(navigatorKey.currentContext!);
          }
        },
      );
  Future<void> _waitForDeviceConnection() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected) {
      // The device is still not connected, re-schedule this method
      Future.delayed(const Duration(seconds: 1), _waitForDeviceConnection);
    } else {
      setState(() {
        isNetwork.value = true;
      });
      // The device is now connected, proceed with your logic
      Navigator.pop(navigatorKey.currentContext!, 'Cancel');
    }
  }

  List<String> getDeviceType() {
    if (Platform.isAndroid) {
      return ["android", "1.0.0"];
    } else if (Platform.isIOS) {
      return ["ios", "1.0.0"];
    } else {
      return ["", ""];
    }
  }

  _checkApp(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = await HttpServices().postWithAttachments('/api/appversioncheck',
        {"os": getDeviceType()[0], "version": getDeviceType()[1]}, []);
    if (res["status"] == 200) {
      var versionData = json.decode(res["data"]);
      // getNewToken(true);
      setState(() {
        appUpdate = versionData["data"]["normal_update"];
        appForceUpdate = versionData["data"]["force_update"];
        appMaintenence = versionData["data"]["maintenance_break"];
      });
      if (!versionData["data"]["force_update"]) {
        if (versionData["data"]["normal_update"]) {
          prefs.setString(prefKey.versionAvailable, "Available");
        }
      }
    } else {
      setState(() {
        appMaintenence = false;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSplash = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
      home: isSplash
          ? const SplashScreen()
          : !isNetwork.value
              ? const OfflinePage()
              : appMaintenence
                  ? const Maintenance()
                  : appForceUpdate
                      ? const ForceUpdate()
                      : const LoginPage(),
    );
  }
}

// ? const SplashScreen()
//             : !isNetwork.value
//                 ? const OfflinePage()
//                 : appMaintenence
//                     ? const Maintenance()
//                     : appForceUpdate
//                         ? const ForceUpdate()
//                         : _keepmeSigned
//                             ? const Dashboard(
//                                 firstTime: true,
//                               )
//                             : const LoginScreen(),