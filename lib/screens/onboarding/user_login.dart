import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/onboarding/ticketing.dart';
import 'package:sams/widgets/buttons.dart';
import 'package:sams/widgets/textfield.dart';

import '../../utils/strings.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isRemember = false, _showGoogleButton = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signWithGoogle(context) async {
    setState(() {
      _showGoogleButton = true;
    });
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
   
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
        
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    final userCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);
    setState(() {
      _showGoogleButton = false;
    });
    print(userCredentials.user!.displayName);
    print(userCredentials.user!.email);
    print(userCredentials.user!.uid);
    navigateWithRoute(context,  RegisterTicketing(employeeName:userCredentials.user!.displayName));
  }

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
                    style: TextStyle(fontSize: 30, fontFamily: "Serif"),
                  ),
                ),
                CustomLoginTextField(hinText: 'Email', onChanged: (val) {}),
                CustomLoginTextField(hinText: 'Password', onChanged: (val) {}),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: customFlatButtomwithSize('LOGIN', () {}, height * 0.06,
                      width * 0.85, Colors.white, Colors.orange, false),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: width * 0.30,
                        child: const Divider(
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        "Or Login with",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: width * 0.30,
                        child: const Divider(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                googleButton(() => signWithGoogle(context), _showGoogleButton),
                // GestureDetector(
                //   onTap: ()=>signWithGoogle(context),
                //   child: Container(
                //     height: 50,
                //     width: 100,
                //     margin: const EdgeInsets.symmetric(vertical: 20),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey, width: 1),
                //         borderRadius: BorderRadius.circular(15)),
                //     child: Image.asset("assets/png/google_logo.png"),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
