import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  Map drawerData = {"main_items": [], "sub_items": []};

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  // getDrawerData() async {
  //   final res = await HttpServices().getWithToken("/api/common-data", context);
  //   if (res["status"] == 200) {
  //     for (var main in res["data"]["data"]["permissions"]) {
  //       main.forEach((key, value) {
  //         setState(() {
  //           drawerData["main_items"].add(value);
  //         });
  //       });
  //     }
  //     for (var sub in res["data"]["data"]["building_type"]) {
  //       sub.forEach((key, value) {
  //         setState(() {
  //           drawerData["sub_items"].add(value);
  //         });
  //       });
  //     }
  //   } else {
  //     showToast("Something went Wrong in status");
  //   }
  // }

  getAllData() async {
    await getUserDetails(context);
    // await getDrawerData();
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
    var bedCount = dashBoardData["total_beds"] - dashBoardData["empty_beds"];
    return bedCount.toString();
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
                  backgroundColor: const Color.fromRGBO(240, 240, 189, 1),
                  key: _scaffoldKey,
                  body: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04, vertical: h * 0.05),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: const Color(0xFF005689),
                            //   radius: 30,
                            //   child: Image.network(
                            //     userDetails["profile_picture"],
                            //   ),
                            // ),
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: w * 0.55,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello,   ${userDetails["name"]}!",
                                      style: const TextStyle(
                                          fontFamily: "Serif", fontSize: 24),
                                    ),
                                    const Text(
                                      "Have a nice day",
                                      style: TextStyle(
                                          fontFamily: "Poppin", fontSize: 16),
                                    ),
                                  ],
                                )),
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              iconSize: 40,
                              onPressed: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.03),
                          child: DashBoardIconCustom(
                            customWidth: 0.9,
                            customHeight: 0.2,
                            containerColor:
                                const Color.fromRGBO(242, 125, 90, 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                dashboardHeadLabelCount("Available Buildings",
                                    dashBoardData["total_building"].toString()),
                                dashboardHeadLabelCount("No of Rooms",
                                    dashBoardData["total_rooms"].toString()),
                                dashboardHeadLabelCount("Total Capacity",
                                    dashBoardData["total_beds"].toString()),
                              ],
                            ),
                          ),
                        ),
                        ChildWidgetWithSub(
                          subHeading: "Occupied",
                          child1Label: "Rooms",
                          child2Label: "Beds",
                          child1Count:
                              dashBoardData["occupaid_room"].toString(),
                          child2Count: emptyBedCount(),
                          label1Color: const Color.fromRGBO(210, 255, 31, 1),
                          label2Color: const Color.fromRGBO(210, 255, 31, 1),
                        ),
                        ChildWidgetWithSub(
                          subHeading: "Empty",
                          child1Label: "Rooms",
                          child2Label: "Beds",
                          child1Count: dashBoardData["empty_room"].toString(),
                          child2Count: dashBoardData["empty_beds"].toString(),
                          label1Color: const Color.fromRGBO(247, 146, 146, 1),
                          label2Color: const Color.fromRGBO(247, 146, 146, 1),
                        ),
                        DashBoardIconCustom(
                          customWidth: 0.9,
                          customHeight: 0.1,
                          containerColor:
                              const Color.fromRGBO(206, 188, 255, 1),
                          child: Column(
                            children: [
                              const Text(
                                " Hold Beds",
                                style: TextStyle(
                                    fontFamily: "Poppin", fontSize: 22),
                              ),
                              Text(
                                dashBoardData["hold_beds"].toString(),
                                style: const TextStyle(
                                    fontFamily: "Poppin", fontSize: 22),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  endDrawer: EndDrawerCustom(
                    drawerData: drawerData,
                    imageData: userDetails["profile_picture"],
                    userName: userDetails["name"],
                    context: context,
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Container(
                      width: w * 0.6,
                      height: h * 0.06,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.blue.shade600,
                              ),
                              const Text('Home')
                            ],
                          ),
                          InkWell(
                            onTap: () {
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
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                 
                  //  Scaffold(
                  //     key: _scaffoldKey,
                  //     body: Column(
                  //       children: [
                  //         Align(
                  //           alignment: Alignment.topLeft,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(
                  //                 left: 10, top: 15, bottom: 15, right: 5),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text("Hello, ${userDetails["name"]}"),
                  //                 // Row(
                  //                 //   children: [
                  //                 //     Image.asset(
                  //                 //       'assets/png/login_logo.png',
                  //                 //       width: w * 0.40,
                  //                 //       height: h * 0.08,
                  //                 //       fit: BoxFit.fill,
                  //                 //     ),
                  //                 //   ],
                  //                 // ),
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.end,
                  //                   children: [
                  //                     IconButton(
                  //                       icon: CircleAvatar(
                  //                           backgroundColor: const Color(0xFF005689),
                  //                           radius: 20,
                  //                           child: Image.network(
                  //                               userDetails["profile_picture"])),
                  //                       iconSize: 35,
                  //                       onPressed: () {
                  //                         showProfileBottomSheet(
                  //                             context,
                  //                             userDetails["name"],
                  //                             userDetails["profile_picture"], [
                  //                           {
                  //                             "icon": const IconData(0xe491,
                  //                                 fontFamily: 'MaterialIcons'),
                  //                             "title": "Update Profile",
                  //                             "onTap": () {
                  //                               print("object");
                  //                             }
                  //                           },
                  //                           {
                  //                             "icon": Icons.verified_user_outlined,
                  //                             "title": "User Directory",
                  //                             "onTap": () {
                  //                               print("object");
                  //                             }
                  //                           },
                  //                           {
                  //                             "icon": Icons.logout_outlined,
                  //                             "title": "Logout",
                  //                             "onTap": () {
                  //                               showAlertBox(
                  //                                   'Confirm Logout',
                  //                                   'Are you sure you want to Logout?',
                  //                                   'Logout',
                  //                                   () {
                  //                                     logoutCall(context);
                  //                                   },
                  //                                   'Cancel',
                  //                                   () {
                  //                                     Navigator.pop(context);
                  //                                   },
                  //                                   context);
                  //                             }
                  //                           },
                  //                         ]);
                  //                       },
                  //                     ),
                  //                     // IconButton(
                  //                     //   icon: const Icon(Icons.menu),
                  //                     //   iconSize: 30,
                  //                     //   onPressed: () {
                  //                     //     _scaffoldKey.currentState!.openEndDrawer();
                  //                     //   },
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //     //     Expanded(
                  //     //       child: SizedBox(
                  //     //         height: h * 0.84,
                  //     //         child: ListView.builder(
                  //     //           // scrollDirection: Axis.vertical,
                  //     //           itemCount: dashBoardMain.length,
                  //     //           itemBuilder: (context, index) {
                  //     //             return DashboardWidgetContainer(
                  //     //                 widgetName: dashBoardMain[index]["name"],
                  //     //                 icon: dashBoardMain[index]["icon"],
                  //     //                 color1: dashBoardMain[index]["color1"],
                  //     //                 color2: dashBoardMain[index]["color2"],
                  //     //                 color3: dashBoardMain[index]["color3"],
                  //     //                 onClick: dashBoardMain[index]["onClick"],
                  //     //                 count: dashBoardMain[index]["count"]);
                  //     //           },
                  //     //         ),
                  //     //       ),
                  //     //     ),
                  //       ],
                  //     ),

                  //     endDrawer: EndDrawerCustom(
                  //       imageData: userDetails["profile_picture"],
                  //       userName: userDetails["name"], context: context,
                  //     )),
                  ),
        ));
  }
}
