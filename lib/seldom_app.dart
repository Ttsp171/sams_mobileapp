import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'config/prefs.dart';
import 'screens/onboarding/login.dart';
import 'screens/onboarding/splash.dart';

SharedPreferanceKeyString prefKey = SharedPreferanceKeyString();

class SeldomApp extends StatefulWidget {
  const SeldomApp({super.key});

  @override
  State<SeldomApp> createState() => _SeldomAppState();
}

class _SeldomAppState extends State<SeldomApp> {
  bool isSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isSplash ? const SplashScreen() : const LoginPage(),
    );
  }
}
