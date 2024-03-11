import 'package:flutter/material.dart';
import 'package:sams/widgets/buttons.dart';
import 'package:sams/widgets/textfield.dart';

import '../../utils/strings.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
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
                    Strings.userLoginWelcomeText,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                CustomLoginTextField(hinText: 'Email', onChanged: (val) {}),
                CustomLoginTextField(hinText: 'Password', onChanged: (val) {}),
               Padding(
                  padding: const EdgeInsets.all(10),
                  child: customFlatButtomwithSize('LOGIN', () {}, height * 0.06,
                      width * 0.85, Colors.white, Colors.orange, false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
