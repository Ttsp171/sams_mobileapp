import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/onboarding/login.dart';

import '../../services/api.dart';
import '../../utils/colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = "", otp = "", password = "", confirmPassword = "";
  String? _emailError, otpError, passwordError, confirmPassError;
  bool _isFirstTime = true,
      _isPassFirstTime = true,
      showButton = false,
      showSubmitButton = false,
      showPasswordField = false;

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

  void validateOtp(String value) {
    RegExp regex = RegExp(r'^\d{4}$');
    if (value.isEmpty) {
      setState(() {
        otpError = 'OTP is required';
      });
    } else if (!regex.hasMatch(value)) {
      setState(() {
        otpError = 'OTP should be exactly 4 digits long';
      });
    } else {
      setState(() {
        otpError = null;
      });
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        passwordError = 'New Password is required';
      });
    } else if (value.contains(" ")) {
      setState(() {
        passwordError = 'Password should not with empty spaces';
      });
    } else if (value.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters long';
      });
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      setState(() {
        passwordError =
            'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
      });
    } else {
      setState(() {
        passwordError = null;
      });
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        confirmPassError = 'Confirm Password is required';
      });
    } else if (value.contains(" ")) {
      setState(() {
        confirmPassError = 'Confirm Password should not with empty spaces';
      });
    } else if (value != password) {
      setState(() {
        confirmPassError = 'Confirm Passwords do not match';
      });
    } else {
      setState(() {
        confirmPassError = null;
      });
    }
  }

  _submitForm() {
    _validateEmail(email);

    if (_emailError == null) {
      sendOtp(context);
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  _submitSecondForm() {
    validatePassword(password);
    validateConfirmPassword(confirmPassword);
    validateOtp(otp);

    if (otpError == null && passwordError == null && confirmPassError == null) {
      resetPassword(context);
    } else {
      setState(() {
        showSubmitButton = false;
      });
    }
  }

  resetPassword(context) async {
    print("**********RESET CALL************");
    final res = await HttpServices().post(
        '/api/reset-password?type=2&email=$email&password=$password&otp=$otp',
        context);
    if (res["status"] == 200) {
      setState(() {
        showSubmitButton = false;
      });
      showSuccessToast(res["data"]["message"]);
      navigateWithoutRoute(context, const LoginPage());
    } else {
      setState(() {
        showSubmitButton = false;
      });
      showToast(res["data"]["message"]);
    }
  }

  sendOtp(context) async {
    print("**********OTP CALL************");
    final res = await HttpServices()
        .post('/api/reset-password?type=1&email=$email', context);
    if (res["status"] == 200) {
      setState(() {
        showButton = false;
        showPasswordField = true;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      setState(() {
        showButton = false;
      });
      showToast(res["data"]["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      appBar: AppBar(
        title:
            const Text('Reset Password', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: ColorTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
        child: Center(
          child: Column(
            children: [
              CustomTextFieldWithLabel(
                errorText: _emailError,
                labelText: 'Enter your Email',
                required: true,
                hintText: "Email",
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                  if (!_isFirstTime) {
                    _validateEmail(val);
                  }
                },
              ),
              customFlatButtomwithSize('Send Otp', () {
                setState(() {
                  showButton = true;
                  _isFirstTime = false;
                });
                _submitForm();
              }, height * 0.05, width * 0.45, Colors.orange, Colors.orange,
                  Colors.white, showButton),
              SizedBox(
                height: height * 0.1,
              ),
              if (showPasswordField)
                Column(
                  children: [
                    CustomTextFieldWithLabel(
                      errorText: otpError,
                      isErrorBottom: "1",
                      labelText: 'Enter Otp',
                      required: true,
                      hintText: "OTP",
                      onChanged: (val) {
                        setState(() {
                          otp = val;
                        });
                        if (!_isPassFirstTime) {
                          validateOtp(val);
                        }
                      },
                    ),
                    CustomTextFieldWithLabel(
                      errorText: passwordError,
                      isErrorBottom: "1",
                      labelText: 'New Password',
                      required: true,
                      hintText: "New Password",
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                        if (!_isPassFirstTime) {
                          validatePassword(val);
                        }
                      },
                    ),
                    CustomTextFieldWithLabel(
                      errorText: confirmPassError,
                      isErrorBottom: "1",
                      labelText: 'Confirm New Password',
                      required: true,
                      hintText: "Confirm New Password",
                      onChanged: (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                        if (!_isPassFirstTime) {
                          validateConfirmPassword(val);
                        }
                      },
                    ),
                    customFlatButtomwithSize('Reset', () {
                      setState(() {
                        showSubmitButton = true;
                        _isPassFirstTime = false;
                      });
                      _submitSecondForm();
                    }, height * 0.05, width * 0.45, Colors.white, Colors.white,
                        Colors.orange, showSubmitButton),
                  ],
                )
            ],
          ),
        ),
      ),
      //  CustomLoginTextField(
      //   hinText: "Email",
      //   errorText: _emailError,
      //   onChanged: (val) {
      //     setState(() {
      //       email = val;
      //     });
      //     if (!_isFirstTime) {
      //       _validateEmail(val);
      //     }
      //   },
      // ),
    );
  }
}
