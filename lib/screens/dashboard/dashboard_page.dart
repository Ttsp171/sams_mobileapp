import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sams/screens/dashboard/drawer.dart';
import 'package:sams/utils/colors.dart';
import 'package:sams/widgets/common_widget.dart';

import '../../controllers/logout_controllers.dart';
import '../../services/api.dart';
import '../../widgets/alert_dailog.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/toast.dart';

class DashBoardMain extends StatefulWidget {
  const DashBoardMain({super.key});

  @override
  State<DashBoardMain> createState() => _DashBoardMainState();
}

class _DashBoardMainState extends State<DashBoardMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _show = true;
  Map userDetails = {};
  Map dashBoardData = {};
  List dashBoardMain = [];

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    await getUserDetails(context);
    print(dashBoardData);
    setState(() {
      dashBoardMain.addAll([
        {
          "name": "Occupied Rooms",
          "icon": Icons.home,
          "count": dashBoardData["occupaid_room"].toString(),
          "color1": Colors.pink.shade300,
          "color2": Colors.pink.shade200,
          "color3": Colors.grey,
          "onClick": () {}
        },
        {
          "name": "Empty Rooms",
          "icon": Icons.home,
          "count": dashBoardData["empty_room"].toString(),
          "color1": Colors.blue.shade300,
          "color2": Colors.blue.shade200,
          "color3": Colors.grey,
          "onClick": () {}
        },
        {
          "name": "Occupied Beds",
          "icon": Icons.home,
          "count": dashBoardData["occupaid_room"].toString(),
          "color1": Colors.orange.shade300,
          "color2": Colors.orange.shade200,
          "color3": Colors.grey,
          "onClick": () {}
        },
        {
          "name": "Empty Beds",
          "icon": Icons.home,
          "count": dashBoardData["empty_beds"].toString(),
          "color1": Colors.yellow.shade300,
          "color2": Colors.yellow.shade200,
          "color3": Colors.grey,
          "onClick": () {}
        },
        {
          "name": "Hold Beds",
          "icon": Icons.home,
          "count": dashBoardData["hold_beds"].toString(),
          "color1": Colors.brown.shade300,
          "color2": Colors.brown.shade200,
          "color3": Colors.grey,
          "onClick": () {}
        }
      ]);
    });
  }

  getUserDetails(context) async {
    final res = await HttpServices().getWithToken('/api/user-details', context);
    if (res["status"] == 200) {
      setState(() {
        _show = false;
        userDetails = res["data"]["data"]["user_details"] ?? {};
        dashBoardData = res["data"]["data"]["dashboard_data"] ?? {};
      });
    } else {
      setState(() {
        _show = false;
      });
      showToast(res["data"]["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
        child: _show
            ? Scaffold(
                backgroundColor: Colors.white60,
                body: SizedBox(
                  width: w,
                  height: h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ColorTheme.primaryColor,
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                key: _scaffoldKey,
                body: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 15, bottom: 15, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/png/login_logo.png',
                                  width: w * 0.40,
                                  height: h * 0.08,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: CircleAvatar(
                                      backgroundColor: const Color(0xFF005689),
                                      radius: 20,
                                      child: Image.network(
                                          userDetails["profile_picture"])),
                                  iconSize: 35,
                                  onPressed: () {
                                    showProfileBottomSheet(
                                        context,
                                        userDetails["name"],
                                        userDetails["profile_picture"], [
                                      {
                                        "icon": const IconData(0xe491,
                                            fontFamily: 'MaterialIcons'),
                                        "title": "Update Profile",
                                        "onTap": () {
                                          print("object");
                                        }
                                      },
                                      {
                                        "icon": Icons.verified_user_outlined,
                                        "title": "User Directory",
                                        "onTap": () {
                                          print("object");
                                        }
                                      },
                                      {
                                        "icon": Icons.logout_outlined,
                                        "title": "Logout",
                                        "onTap": () {
                                          showAlertBox(
                                              'Confirm Logout',
                                              'Are you sure you want to Logout?',
                                              'Logout',
                                              () {
                                                logoutCall(context);
                                              },
                                              'Cancel',
                                              () {
                                                Navigator.pop(context);
                                              },
                                              context);
                                        }
                                      },
                                    ]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.menu),
                                  iconSize: 30,
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openEndDrawer();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: h * 0.84,
                        child: ListView.builder(
                          // scrollDirection: Axis.vertical,
                          itemCount: dashBoardMain.length,
                          itemBuilder: (context, index) {
                            return DashboardWidgetContainer(
                                widgetName: dashBoardMain[index]["name"],
                                icon: dashBoardMain[index]["icon"],
                                color1: dashBoardMain[index]["color1"],
                                color2: dashBoardMain[index]["color2"],
                                color3: dashBoardMain[index]["color3"],
                                onClick: dashBoardMain[index]["onClick"],
                                count: dashBoardMain[index]["count"]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                endDrawer: EndDrawerCustom(
                  imageData: userDetails["profile_picture"],
                  userName: userDetails["name"], context: context,
                )),
      ),
    );
  }
}
