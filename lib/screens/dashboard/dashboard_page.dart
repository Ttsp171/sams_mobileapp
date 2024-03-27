import 'package:flutter/material.dart';
import 'package:sams/utils/colors.dart';

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
  bool _show = true;
  Map userDetails = {};

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
  }

  getUserDetails(context) async {
    final res = await HttpServices().getWithToken('/api/user-details', context);
    if (res["status"] == 200) {
      setState(() {
        _show = false;
        userDetails = res["data"]["data"] ?? {};
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
                    body: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 15, bottom: 15, right: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            backgroundColor:
                                                const Color(0xFF005689),
                                            radius: 20,
                                            child: Image.network(userDetails[
                                                "profile_picture"])),
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
                                              "icon":
                                                  Icons.verified_user_outlined,
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
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )));
  }
}
