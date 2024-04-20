import 'package:flutter/material.dart';
import 'package:sams/utils/colors.dart';

import '../screens/maintenance/force_update.dart';

showAlertBox(title, content, postiveButton, postiveAction, negativeButton,
    negativeAction, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
              onPressed: negativeAction,
              child: Text(
                negativeButton,
                style: const TextStyle(color: Colors.black),
              )),
          TextButton(
              onPressed: postiveAction,
              child: Text(
                postiveButton,
                style: TextStyle(color: ColorTheme.primaryColor),
              )),
        ],
      );
    },
  );
}

showTextFieldAlert(title, hintText,  initialValue, onChanged,
    postiveAction,positiveButton, negativeAction, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 248, 239, 224),
        title: Text(title),
        content: Container(
          padding: const EdgeInsets.only(left: 15),
          decoration: const BoxDecoration(color: Colors.white),
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
            onChanged: onChanged,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: negativeAction,
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
              onPressed: postiveAction,
              child: Text(
                positiveButton,
                style: TextStyle(color: ColorTheme.primaryColor),
              )),
        ],
      );
    },
  );
}

showUpdateAlert(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Update Available',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
              'A new version of the app is available. Would you like to update it?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Remind Me Later',
                style: TextStyle(color: Color(0xff012B4E)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                const ForceUpdate().openStore(context);
              },
              child: const Text(
                'Update Now',
                style: TextStyle(color: Color(0xff012B4E)),
              ),
            ),
          ],
        );
      });
}
