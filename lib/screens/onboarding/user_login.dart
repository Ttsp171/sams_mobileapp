import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/onboarding/ticketing.dart';
import 'package:sams/services/api.dart';

import '../../utils/colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/toast.dart';

class UserLoginPage extends StatefulWidget {
  final double w;
  final double h;
  const UserLoginPage({super.key, required this.w, required this.h});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isRemember = false, _showGoogleButton = false, passVisible = true;
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
    try {
      final res =
          await HttpServices().postWithAttachments('/api/google-login', {
        'email': userCredentials.user!.email.toString(),
        'user_name': userCredentials.user!.displayName.toString(),
        'google_token': userCredentials.user!.uid.toString()
      }, []);
      if (res["status"] == 200) {
        var resData = json.decode(res["data"]);
       resData["data"]["is_registered"]=="yes" ?showSuccessToast(
            "Welcome back ${userCredentials.user!.email}"):showSuccessToast(
            "${resData["message"]??""} from ${userCredentials.user!.email}");
        Navigator.pop(context);
        navigateWithRoute(context,
            RegisterTicketing(userData: resData["data"]??{}));
        setState(() {
          _showGoogleButton = false;
        });
      } else {
        setState(() {
          _showGoogleButton = false;
        });
      }
    } catch (e) {
      setState(() {
        _showGoogleButton = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: widget.h * 0.1, horizontal: widget.w * 0.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/svg/google_logo.svg",
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: Text('Are you continue with Google',
                style: TextStyle(
                  fontSize: 30,
                  color: ColorTheme.textBlack,
                )),
          ),
          SizedBox(
              width: widget.w * 0.8,
              child: RichText(
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Seldom Asset App ',
                  style: TextStyle(
                    fontFamily: "Serif",
                    fontSize: 22,
                    color: ColorTheme.textBlack,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "collects your name, email address, and profile picture. For more related queries see Seldom's privacy policy and terms of service.",
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorTheme.textBlack.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: customFlatButtomwithSize('Cancel', () {
                    Navigator.pop(context);
                    //  navigateWithRoute(context, const UserLoginPage());
                  }, h * 0.06, w * 0.30, Colors.orange, Colors.orange,
                      Colors.white, false),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: customFlatButtomwithSize('Confirm', () {
                    signWithGoogle(context);
                  }, h * 0.06, w * 0.30, Colors.white, Colors.white,
                      Colors.orange, _showGoogleButton),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
