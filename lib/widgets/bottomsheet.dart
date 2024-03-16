import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

googleSignInSheet(BuildContext context, child) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: Platform.isAndroid ? .55 : .65,
            builder: (_, controller) {
              return child;
            });
      });
}

Future<bool> showExitPopup(context) async {
  return await showDialog(
        context: context,
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            title: const Text(
              'Exit App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: const Text('Do you want to exit an App?',
                style: TextStyle(fontSize: 15, color: Colors.black)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pop(false),
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:const MaterialStatePropertyAll(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      )),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      onPressed: () => {
                        SystemNavigator.pop()
                        // Navigator.of(context).pop(true),
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:const MaterialStatePropertyAll(Colors.orange),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        )),
                      ),
                      child: const Text(
                        'Leave',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      false;
}
