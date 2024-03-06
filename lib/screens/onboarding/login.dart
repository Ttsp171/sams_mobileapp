import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/onboarding/ticketing.dart';
import 'package:sams/widgets/buttons.dart';
import 'package:sams/widgets/textfield.dart';

import '../../utils/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 239, 224),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTicketButton(
                buttonText: Strings.ticketingButtonText,
                onPressed: () {
                  navigateWithRoute(context, const RegisterTicketing());
                }),
          )
        ],
      ),
      body: Column(
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
          customFlatButtomwithSize('LOGIN', () {}, height * 0.06, width * 0.85,
              Colors.white, Colors.orange, false)
        ],
      ),
    );
  }
}
