import 'package:flutter/material.dart';

class CustomFilePicker extends StatefulWidget {
  final String labelText;
  final String uploadText;
  final String fileText;
  final bool isRequired;
  final Function onPressed;
  final String? errorText;
  const CustomFilePicker(
      {super.key,
      required this.labelText,
      required this.uploadText,
      required this.fileText,
      required this.onPressed,
      required this.isRequired,
      this.errorText});

  @override
  State<CustomFilePicker> createState() => _CustomFilePickerState();
}

class _CustomFilePickerState extends State<CustomFilePicker> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: SizedBox(
        width: width * 0.85,
        height: height * 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  widget.labelText,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                if (widget.isRequired)
                  const Text(
                    " *",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.red,
                    ),
                  ),
                if (widget.errorText != null)
                  Text(
                    "   ${widget.errorText}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Container(
              width: width * 0.85,
              height: height * 0.05,
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    width: width * 0.30,
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Center(child: Text(widget.uploadText)),
                  ),
                  Container(
                    width: width * 0.55,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Center(
                      child: Text(widget.fileText),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
