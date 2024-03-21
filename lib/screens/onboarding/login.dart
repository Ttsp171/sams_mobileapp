import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/maintenance/privacy_policy.dart';
import 'package:sams/widgets/bottomsheet.dart';

import '../../widgets/buttons.dart';
import '../../widgets/textfield.dart';
import 'user_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRemember = false,
      passVisible = true,
      showLogin = false,
      showTicketing = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromRGBO(255, 167, 23, 1),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: h * 0.47,
                    width: w * 0.95,
                    margin: EdgeInsets.only(top: h * 0.01, left: 10, right: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                            bottomLeft: Radius.elliptical(50, 100),
                            bottomRight: Radius.elliptical(50, 100))),
                  ),
                  Container(
                    height: h * 0.47,
                    width: w * 0.95,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                            topLeft: Radius.elliptical(50, 100),
                            topRight: Radius.elliptical(50, 100))),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(h * 0.05),
                    child: Image.asset(
                      "assets/png/login_logo.png",
                      height: h * 0.15,
                      width: w * 0.70,
                    ),
                  ),
                  Container(
                      margin:
                          EdgeInsets.only(left: w * 0.10, bottom: h * 0.02),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Serif",
                            color: Color.fromRGBO(255, 167, 23, 1)),
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: CustomLoginTextField(
                          hinText: "Email", onChanged: (val) {})),
                  Container(
                      alignment: Alignment.center,
                      child: CustomLoginTextField(
                        hinText: 'Password',
                        onChanged: (val) {},
                        suffixIcon: passVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        suffixIconPressed: () {
                          setState(() {
                            passVisible = !passVisible;
                          });
                        },
                        obscureText: passVisible,
                      )),
              
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
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 5),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5),
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
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 5),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5),
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
                            onPressed: () {
                              // navigateWithRoute(context, const PrivacyPolicy());
                            },
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: customFlatButtomwithSize(
                            'LOGIN',
                            () {},
                            h * 0.06,
                            w * 0.42,
                            Colors.white,
                            Colors.white,
                            Colors.orange,
                            showLogin),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: customFlatButtomwithSize('Ticketing', () {
                          googleSignInSheet(
                              context,
                              UserLoginPage(
                                h: h * 0.50,
                                w: w,
                              ));
                          //  navigateWithRoute(context, const UserLoginPage());
                        }, h * 0.06, w * 0.42, Colors.orange, Colors.orange,
                            Colors.white, showTicketing),
                      ),
                    ],
                  ),
                  // Container(
                  //   alignment: Alignment.bottomCenter,
                  //   margin: EdgeInsets.only(bottom: h * 0.01),
                  //   child: Column(
                  //     children: [
                  //       const Text(
                  //           "By creating an account, you agree with our"),
                  //       TextButton(
                  //           onPressed: () {
                  //             navigateWithRoute(
                  //                 context, const PrivacyPolicy());
                  //           },
                  //           child: const Text(
                  //             "Terms of Service & Privacy Policy",
                  //             style: TextStyle(color: Colors.blue),
                  //           ))
                  //     ],
                  //   ),
                  // ),
              
                  // Image.asset("assets/jpg/touch_back.jpg",height: h*0.30,)
                ],
              ),
                Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: h*0.75),
                child: Column(
                  children: [
                    const Text("By creating an account, you agree with our",style: TextStyle(fontFamily: "Serif",fontSize: 18),),
                      TextButton(
                              onPressed: () {
                                navigateWithRoute(context, const PrivacyPolicy());
                              },
                              child: const Text(
                                "Terms of Service & Privacy Policy",
                                style: TextStyle(fontFamily: "Serif",fontSize: 18,color: Colors.blue),
                              ))

                  ],
                ),
              ),
            ],
          ),
          
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // floatingActionButton:  Container(
          //     alignment: Alignment.bottomCenter,
          //     margin: EdgeInsets.only(bottom: h*0.01),
          //     child: Column(
          //       children: [
          //         const Text("By creating an account, you agree with our"),
          //           TextButton(
          //                   onPressed: () {
          //                     navigateWithRoute(context, const PrivacyPolicy());
          //                   },
          //                   child: const Text(
          //                     "Terms of Service & Privacy Policy",
          //                     style: TextStyle(color: Colors.blue),
          //                   ))

          //       ],
          //     ),
          //   ),
          // bottomNavigationBar:  Container(
          //     alignment: Alignment.bottomCenter,
          //     margin: EdgeInsets.only(bottom: h*0.01),
          //     child: Column(
          //       children: [
          //         const Text("By creating an account, you agree with our"),
          //           TextButton(
          //                   onPressed: () {
          //                     navigateWithRoute(context, const PrivacyPolicy());
          //                   },
          //                   child: const Text(
          //                     "Terms of Service & Privacy Policy",
          //                     style: TextStyle(color: Colors.blue),
          //                   ))

          //       ],
          //     ),
          //   ),
        ),
      ),
    );
  }
}
