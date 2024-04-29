import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

googleSignInSheet(BuildContext context, child) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: Platform.isAndroid ? .55 : .65,
            builder: (_, controller) {
              return child;
            });
      });
}

Future<bool> showExitPopup(context) async {
  return await showDialog(
        context: context,
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            title: const Text(
              'Exit App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: const Text('Do you want to exit an App?',
                style: TextStyle(fontSize: 15, color: Colors.black)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pop(false),
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () => {SystemNavigator.pop()},
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.orange),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        )),
                      ),
                      child: const Text(
                        'Leave',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      false;
}

void showProfileBottomSheet(context, userName, profileImage, profileSheetData) {
  showModalBottomSheet(
    isDismissible: false,
    useSafeArea: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      //  double w = MediaQuery.of(context).size.width;
      double h = MediaQuery.of(context).size.height;
      return Container(
        height: h * 0.50,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 5,
                      width: 100,
                      decoration: const ShapeDecoration(
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                    ),
                  ),
                ),
              
                profileImage != ""
                    ? Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: h * 0.1,
                          width: h * 0.1,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(99))),
                          child: ClipOval(
                              child: Image.network(
                            profileImage,
                            fit: BoxFit.fill,
                          )),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            child: SvgPicture.asset(
                                "assets/svg/profile_icon.svg")),
                      ),
                // IconButton(
                //   icon: CircleAvatar(
                //       backgroundColor: const Color(0xFF005689),
                //       radius: 40,
                //       child: Image.network(profileImage)),
                //   iconSize: 80,
                //   onPressed: () {},
                // ),
                const SizedBox(height: 10),
                Text(
                  "$userName",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: profileSheetData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(profileSheetData[index]["icon"]),
                        title: Text(profileSheetData[index]["title"]),
                        onTap: profileSheetData[index]["onTap"],
                      );
                    },
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      );
    },
  );
}
