import 'package:flutter/material.dart';

class CustomLoginTextField extends StatefulWidget {
  final String hinText;
  final ValueChanged onChanged;
  final String? errorText;
  const CustomLoginTextField(
      {super.key,
      required this.hinText,
      required this.onChanged,
      this.errorText});

  @override
  State<CustomLoginTextField> createState() => _CustomLoginTextFieldState();
}

class _CustomLoginTextFieldState extends State<CustomLoginTextField> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.85,
      height: height * 0.10,
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelText: widget.hinText,
          hintText: widget.hinText,
          errorText: widget.errorText,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class CustomTextFieldWithLabel extends StatelessWidget {
  final String labelText;
  final bool required;
  final String hintText;
  final ValueChanged onChanged;
  final bool? readOnly;
  final int? maxLines;
  final String? initialValue;
  final int? maxLength;
  final String? errorText;
  const CustomTextFieldWithLabel(
      {super.key,
      required this.labelText,
      required this.required,
      required this.hintText,
      required this.onChanged,
      this.maxLines,
      this.readOnly,
      this.initialValue,
      this.errorText,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.85,
      height: height * 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                labelText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              if (required)
                const Text(
                  " *",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: const BoxDecoration(color: Colors.white),
            child: TextFormField(
              maxLength: maxLength,
              readOnly: readOnly ?? false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: errorText,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey)),
              onChanged: onChanged,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      ),
    );
  }
}
