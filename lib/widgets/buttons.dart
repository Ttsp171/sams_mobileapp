import 'package:flutter/material.dart';

class CustomTicketButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const CustomTicketButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: Colors.blue)),
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }
}

Widget customButtomwithSize(
    buttonText, onButtonClick, height, width, textColor, buttonColor, show) {
  return SizedBox(
    height: height,
    width: width,
    child: ElevatedButton(
      onPressed: !show ? onButtonClick : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: show
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: textColor,
              ),
            )
          : Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
    ),
  );
}

Widget customFlatButtomwithSize(
    buttonText, onButtonClick, height, width, textColor, buttonColor, show) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: !show ? onButtonClick : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: show
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: textColor,
                ),
              )
            : Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
      ),
    ),
  );
}
