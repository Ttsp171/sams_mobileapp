import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/widgets/buttons.dart';
import 'package:sams/widgets/textfield.dart';

import '../../utils/strings.dart';
import 'user_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: CustomTicketButton(
      //           buttonText: Strings.ticketingButtonText,
      //           onPressed: () {
      //             navigateWithRoute(context, const RegisterTicketing());
      //           }),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/png/login_logo.png',
                    height: 150,
                    width: 200,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: height * 0.1,
                  width: width * 0.85,
                  child: const Text(
                    Strings.loginWelcomeText,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                CustomLoginTextField(hinText: 'Email', onChanged: (val) {}),
                CustomLoginTextField(hinText: 'Password', onChanged: (val) {}),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRemember = !isRemember;
                            });
                          },
                          child: Row(
                            children: [
                              if (isRemember)
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, right: 5),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              if (!isRemember)
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, right: 5),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                ),
                              const Text("Remember me",
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: customFlatButtomwithSize('LOGIN', () {}, height * 0.06,
                      width * 0.85, Colors.white, Colors.orange, false),
                ),
              ],
            ),
          ),
            Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 30, right: 20),
            child: CustomTicketButton(
                buttonText: Strings.ticketingButtonText,
                onPressed: () {
                  navigateWithRoute(context, const UserLoginPage());
                }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: width,
        height: height * 0.12,
        color: Colors.orange,
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.getinTouchText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      Strings.emailOffical,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 20,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Text(
                      Strings.phoneOfficial,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
