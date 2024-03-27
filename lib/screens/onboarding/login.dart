import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/dashboard/dashboard_page.dart';
import 'package:sams/screens/maintenance/privacy_policy.dart';
import 'package:sams/seldom_app.dart';
import 'package:sams/widgets/bottomsheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api.dart';
import '../../widgets/buttons.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';
import 'user_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRemember = false,
      passVisible = true,
      showTicketing = false,
      _show = false,
      _isFirstTime = true;
  String email = "", password = "";
  String? _emailError;
  String? _passwordError;

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      setState(() {
        _emailError = 'Enter a valid email';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _submitForm() {
    _validateEmail(email);
    _validatePassword(password);

    if (_emailError == null && _passwordError == null) {
      loginUser(context);
    } else {
      setState(() {
        _show = false;
      });
    }
  }

  loginUser(context) async {
    print("**********LOGIN CALL************");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = await HttpServices().authBoardPost(
        '/api/user-login', {'email': email, 'password': password});
    if (res["status"] == 200) {
      await prefs.setString(prefKey.token, res["data"]["data"]["token"] ?? "");
      await prefs.setBool(prefKey.isRemember, isRemember);
      // await prefs.setString(prefKey.u1, email);
      // await prefs.setString(prefKey.u2, password);

      setState(() {
        _show = false;
      });
      navigateWithoutRoute(context, const DashBoardMain());
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
                      margin: EdgeInsets.only(left: w * 0.10, bottom: h * 0.02),
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
                          hinText: "Email",
                          errorText: _emailError,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                            if (!_isFirstTime) {
                              _validateEmail(val);
                            }
                          })),
                  Container(
                      alignment: Alignment.center,
                      child: CustomLoginTextField(
                        hinText: 'Password',
                        errorText: _passwordError,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                          if (!_isFirstTime) {
                            _validatePassword(val);
                          }
                        },
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
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 5),
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
                        child: customFlatButtomwithSize('LOGIN', () {
                          setState(() {
                            _show = true;
                            _isFirstTime = false;
                          });
                          _submitForm();
                        }, h * 0.06, w * 0.42, Colors.white, Colors.white,
                            Colors.orange, _show),
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
                        }, h * 0.06, w * 0.42, Colors.orange, Colors.orange,
                            Colors.white, showTicketing),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: h * 0.75),
                child: Column(
                  children: [
                    const Text(
                      "By creating an account, you agree with our",
                      style: TextStyle(fontFamily: "Serif", fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          navigateWithRoute(context, const PrivacyPolicy());
                        },
                        child: const Text(
                          "Terms of Service & Privacy Policy",
                          style: TextStyle(
                              fontFamily: "Serif",
                              fontSize: 18,
                              color: Colors.blue),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
