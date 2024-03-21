import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sams/firebase_options.dart';

import 'seldom_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final bool isDeviceConnected =
      await InternetConnectionChecker().hasConnection;
  runApp(SeldomApp(
    isNetworkConnect: isDeviceConnected,
  ));
}
