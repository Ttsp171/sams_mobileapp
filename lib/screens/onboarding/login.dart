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
      body: SingleChildScrollView(
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
            // Row(
            //   children: [
            //     Checkbox(
            //         value: true,
            //         onChanged: (val) {},
            //         checkColor: Colors.purple,
            //         side: const BorderSide(width: 0.5, color: Colors.grey),
            //         shape: BeveledRectangleBorder(
            //             borderRadius: BorderRadius.circular(5),
            //             side:
            //                 const BorderSide(width: 0.5, color: Colors.black)),
            //         fillColor:
            //             const MaterialStatePropertyAll(Colors.transparent)),
            //     const Text("data"),
            //   ],
            // ),
            customFlatButtomwithSize('LOGIN', () {}, height * 0.06,
                width * 0.85, Colors.white, Colors.orange, false)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
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
