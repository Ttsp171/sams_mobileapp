import 'package:flutter/material.dart';

import '../../widgets/bottomsheet.dart';

class DashBoardMain extends StatefulWidget {
  final Map userData;
  const DashBoardMain({super.key, required this.userData});

  @override
  State<DashBoardMain> createState() => _DashBoardMainState();
}

class _DashBoardMainState extends State<DashBoardMain> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: const SafeArea(child: Scaffold()));
  }
}
