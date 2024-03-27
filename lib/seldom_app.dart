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
import 'screens/dashboard/dashboard_page.dart';
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
  bool isSplash = true;
  bool appMaintenence = false;
  bool appUpdate = false;
  bool appForceUpdate = false;
  bool isDeviceConnected = false;
  bool isDashBoard = false;
  late StreamSubscription subscription;
  ValueNotifier<bool> isNetwork = ValueNotifier<bool>(false);
  Map userDetails = {};

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
      getIsRemember(context);
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

  getIsRemember(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRemem = prefs.getBool(prefKey.isRemember) ?? false;
    if (isRemem) {
      setState(() {
        isDashBoard = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSplash = false;
        });
      });
    } else {
      prefs.clear();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSplash = false;
        });
      });
    }
  }

  // loginUser(context) async {
  //   print("**********RE LOGIN CALL************");
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var email = prefs.getString(prefKey.u1);
  //   var password = prefs.getString(prefKey.u2);
  //   final res = await HttpServices().authBoardPost(
  //       '/api/user-login', {'email': email, 'password': password});
  //   if (res["status"] == 200) {
  //     await prefs.setString(prefKey.token, res["data"]["data"]["token"] ?? "");
  //     // getUserDetails(context);
  //     setState(() {
  //       isDashBoard = true;
  //     });
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         isSplash = false;
  //       });
  //     });
  //   } else {
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         isSplash = false;
  //       });
  //     });
  //     showToast(res["data"]["message"]);
  //   }
  // }

  // getUserDetails(context) async {
  //   final res = await HttpServices().getWithToken('/api/user-details', context);
  //   if (res["status"] == 200) {
  //     setState(() {
  //       userDetails = res["data"]["data"];
  //       isDashBoard = true;
  //     });
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         isSplash = false;
  //       });
  //     });
  //   } else {
  //     Future.delayed(const Duration(seconds: 2), () {
  //       setState(() {
  //         isSplash = false;
  //       });
  //     });
  //     showToast(res["data"]["message"]);
  //   }
  // }

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
                      : isDashBoard
                          ? const DashBoardMain()
                          : const LoginPage(),
    );
  }
}
