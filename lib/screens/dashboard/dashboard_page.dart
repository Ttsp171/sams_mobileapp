import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/utils/colors.dart';
import 'package:sams/widgets/common_widget.dart';

import '../../controllers/logout_controllers.dart';
import '../../services/api.dart';
import '../../widgets/alert_dailog.dart';
import '../../widgets/bottomsheet.dart';
import '../../widgets/toast.dart';
import '../user_directory/user_directory.dart';
import 'drawer.dart';

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
  Map buildingDrawer = {};

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getDrawerData() async {
    final res = await HttpServices()
        .getWithToken('/api/sidebar-buildings-room', context);
    if (res["status"] == 200) {
      setState(() {
        buildingDrawer = res["data"]["data"];
      });
    } else {
      showToast("Something Wrong in Building error");
    }
  }

  getAllData() async {
    await getUserDetails(context);
    await getDrawerData();
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

  String emptyBedCount() {
    var bedCount =
        dashBoardData["total_beds"] - dashBoardData["empty_beds"] ?? "";
    return bedCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
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
              backgroundColor: const Color.fromARGB(255, 239, 223, 195),

              // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              // backgroundColor: Color.fromARGB(161, 230, 191, 191),
              body: Center(
                child: Column(
                  children: [
                    DashBoardTop(
                      imageData: userDetails["profile_picture"] ?? "",
                      userName: userDetails["name"] ?? "",
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: w * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: w * 0.02),
                            child: DashBoardTopContainer(
                              countColor:
                                  ColorTheme.dashboardAvailableCountColor,
                              count: dashBoardData["total_building"].toString(),
                              iconUrl: "assets/svg/building_icon.svg",
                              labelText: "Available\nBuilding",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: w * 0.02),
                            child: DashBoardTopContainer(
                              countColor: ColorTheme.dashboardNoOfCountColor,
                              count: dashBoardData["total_rooms"].toString(),
                              iconUrl: "assets/svg/room_icon.svg",
                              labelText: "No of Rooms",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(w * 0.04),
                      child: DashBoardMiddleSlide(
                        count: dashBoardData["total_beds"].toString(),
                        countColor: ColorTheme.dashboardMiddleTopCountColor,
                        labelText: "Total Capacity",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(w * 0.028),
                      child: DashBoardCenter(
                        countColor: ColorTheme.dashboardMiddleBottomCountColor,
                        labelText: "Occupied",
                        leftCount: dashBoardData["occupaid_room"].toString(),
                        leftLabelText: "Rooms",
                        rightCount: emptyBedCount(),
                        rightLabelText: "Beds",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(w * 0.04),
                      child: DashBoardCenter(
                        countColor: ColorTheme.dashboardMiddleTopCountColor,
                        labelText: "Empty",
                        leftCount: dashBoardData["empty_room"].toString(),
                        leftLabelText: "Rooms",
                        rightCount: dashBoardData["empty_beds"].toString(),
                        rightLabelText: "Beds",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: w * 0.04, left: w * 0.04, right: w * 0.04),
                      child: DashBoardMiddleSlide(
                        count: dashBoardData["hold_beds"].toString(),
                        countColor: ColorTheme.dashboardMiddleBottomCountColor,
                        labelText: "Hold Beds",
                      ),
                    ),
                    DashBoardBottom(
                      onLeftClick: () {
                        showProfileBottomSheet(context, userDetails["name"],
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
                              navigateWithRoute(context, const UserDirectory());
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
                      onRightClick: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                    )
                  ],
                ),
              ),
              endDrawer: EndDrawerCustom(
                drawerData: buildingDrawer,
                imageData: userDetails["profile_picture"],
                userName: userDetails["name"],
                context: context,
              ),
            ),
      onWillPop: () => showExitPopup(context),
    );
  }
}
