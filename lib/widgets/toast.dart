import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(message, bgColor, textColor) {
  FocusManager.instance.primaryFocus?.unfocus();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? Colors.white,
      textColor: textColor ?? Colors.grey);
}
