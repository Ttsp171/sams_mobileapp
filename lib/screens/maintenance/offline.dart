import 'package:flutter/material.dart';
import 'package:sams/utils/colors.dart';

import '../../widgets/bottomsheet.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor:ColorTheme.primaryColor .withOpacity(0.80),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.network_locked,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 20.0),
              Text(
                'No Internet',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Please check your internet connection',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}