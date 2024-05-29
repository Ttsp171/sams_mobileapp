import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/user_directory/user_directory.dart';

import '../../controllers/file_pick_controllers.dart';
import '../../services/api.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/file_choose.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class AddUserDirectory extends StatefulWidget {
  const AddUserDirectory({super.key});

  @override
  State<AddUserDirectory> createState() => _AddUserDirectoryState();
}

class _AddUserDirectoryState extends State<AddUserDirectory> {
  bool showButton = false;
  String fileName = "No File Choosen";
  String? companyName;
  List attachment = [];

  String? usernameError, emailError, phoneError, passwordError, profileError;

  String userName = "", email = "", phoneNumber = "", password = "";

  @override
  void initState() {
    super.initState();
  }

  chooseFile() async {
    var picked = await pickFile();
    if (picked != null) {
      setState(() {
        attachment = picked;
        profileError = null;
      });
    }
  }

  validateUserName() {
    if (userName == "") {
      setState(() {
        usernameError = "Field is Required";
      });
    } else {
      setState(() {
        usernameError = null;
      });
    }
  }

  validateEmail() {
    if (email == "") {
      setState(() {
        emailError = 'Email is required';
      });
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email)) {
      setState(() {
        emailError = 'Enter a valid email';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  validatePhoneNumber() {
    if (phoneNumber == "") {
      setState(() {
        phoneError = "Field is Required";
      });
    } else {
      setState(() {
        phoneError = null;
      });
    }
  }

  validatePassword() {
    if (password == "") {
      setState(() {
        passwordError = "Field is Required";
      });
    } else {
      setState(() {
        passwordError = null;
      });
    }
  }

  validateProfile() {
    if (attachment.isEmpty) {
      setState(() {
        profileError = "Field is Required";
      });
    } else {
      setState(() {
        profileError = null;
      });
    }
  }

  validateFields() {
    validateUserName();
    validateEmail();
    validatePhoneNumber();
    validatePassword();
    validateProfile();
  }

  Future<void> submitForm() async {
    validateFields();

    if (usernameError == null &&
        emailError == null &&
        phoneError == null &&
        passwordError == null &&
        profileError == null) {
      storeUser(context);
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  storeUser(context) async {
    final res = await HttpServices().postWithAttachments(
        '/api/store-user',
        {
          'email': email.toString(),
          'phone_number': phoneNumber.toString(),
          'username': userName.toString(),
          'password': password.toString()
        },
        attachment.isEmpty ? [] : attachment[0]);
    if (res["status"] == 200) {
      setState(() {
        showButton = false;
      });
      var message = json.decode(res["data"]);
      showSuccessToast(message["message"]);
      Navigator.pop(context);
      Navigator.pop(context);
      navigateWithRoute(context, const UserDirectory());
    } else {
      showToast("Error Occured");
      setState(() {
        showButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Add User Form', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: ColorTheme.primaryColor,
      ),
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFieldWithLabel(
                    initialValue: userName,
                    errorText: usernameError,
                    labelText: 'User Name:',
                    required: true,
                    hintText: "Please Enter User Name",
                    onChanged: (val) {
                      setState(() {
                        userName = val;
                      });
                      validateUserName();
                    }),
                CustomTextFieldWithLabel(
                    initialValue: email,
                    errorText: emailError,
                    labelText: 'Email:',
                    required: true,
                    hintText: "Please Enter Email",
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                      validateEmail();
                    }),
                CustomTextFieldWithLabel(
                    initialValue: phoneNumber,
                    errorText: phoneError,
                    labelText: 'Phone Number:',
                    required: true,
                    hintText: "Please Enter Phone Number",
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                      validatePhoneNumber();
                    }),
                CustomTextFieldWithLabel(
                    initialValue: password,
                    errorText: passwordError,
                    labelText: 'Password:',
                    required: true,
                    hintText: "Please Enter Password",
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                      validatePassword();
                    }),
                CustomFilePicker(
                    errorText: profileError,
                    labelText: "Profile Image:",
                    uploadText: "Choose file",
                    fileText: attachment.isNotEmpty ? attachment[1] : fileName,
                    onPressed: () {
                      chooseFile();
                    },
                    isRequired: true),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customButtonWithSize("Save Data", () {
        setState(() {
          showButton = true;
          submitForm();
        });
      }, height * 0.05, width * 0.85, Colors.white, Colors.purple, showButton),
    );
  }
}
