import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';

import '../../widgets/bottomsheet.dart';

class ForceUpdate extends StatelessWidget {
  const ForceUpdate({super.key});

  openStore(context) {
    if (Platform.isAndroid) {
      OpenStore.instance.open(
        androidAppBundleId: 'com.seldom.sams',
      );
    } else if (Platform.isIOS) {
      OpenStore.instance.open(
        appStoreId: '1382963170',
      );
    } else {
      showExitPopup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.70),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    openStore(context);
                  },
                  child: const Text(
                    'Update Now',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/png/login_logo.png', width: 250, height: 150),
                  const Icon(
                    Icons.update_sharp,
                    size: 50,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'A new version of the app is available!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}