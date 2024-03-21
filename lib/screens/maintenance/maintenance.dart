import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sams/utils/colors.dart';

import '../../widgets/bottomsheet.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.70),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/png/login_logo.png', width: 250, height: 150,),
              const Icon(
                Icons.settings,
                size: 50,
                color: Colors.black,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Under Maintenance',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'We are currently performing maintenance.\nPlease check back later.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child:  Text(
                  'Close',
                  style: TextStyle(color: ColorTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}