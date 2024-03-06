import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'config/prefs.dart';
import 'screens/onboarding/login.dart';

SharedPreferanceKeyString prefKey = SharedPreferanceKeyString();

class SeldomApp extends StatefulWidget {
  const SeldomApp({super.key});

  @override
  State<SeldomApp> createState() => _SeldomAppState();
}

class _SeldomAppState extends State<SeldomApp> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
