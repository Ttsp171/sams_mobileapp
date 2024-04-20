import 'package:flutter/material.dart';

class CustomLoginTextField extends StatefulWidget {
  final String hinText;
  final ValueChanged onChanged;
  final String? errorText;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconPressed;
  final bool? obscureText;
  const CustomLoginTextField(
      {super.key,
      required this.hinText,
      required this.onChanged,
      this.errorText,
      this.suffixIcon,
      this.suffixIconPressed,
      this.obscureText});

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
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(widget.suffixIcon),
            onPressed: widget.suffixIconPressed,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelText: widget.hinText,
          hintText: widget.hinText,
          errorText: widget.errorText,
        ),
        onChanged: widget.onChanged,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
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
  final String? isErrorBottom;
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
      this.maxLength,
      this.isErrorBottom});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.85,
      height:errorText != null &&isErrorBottom != null?height * 0.14: height * 0.12,
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
              if (errorText != null && isErrorBottom == null)
                Text(
                  "   $errorText",
                  maxLines: 5,
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(color: Colors.white),
                child: TextFormField(
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  maxLength: maxLength,
                  readOnly: readOnly ?? false,
                  initialValue: initialValue ?? "",
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
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
               SizedBox(
            height: height * 0.01,
          ),
              if (errorText != null && isErrorBottom != null)
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$errorText",
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
            ],
          ),
         
        ],
      ),
    );
  }
}

class SearchFieldWithIcon extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged onCompleted;
  final double? width;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  const SearchFieldWithIcon(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.onCompleted,
      this.onTap,
      this.width,
      this.onChanged});

  @override
  State<SearchFieldWithIcon> createState() => _SearchFieldWithIconState();
}

class _SearchFieldWithIconState extends State<SearchFieldWithIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 220,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onCompleted(widget.controller.text);
              },
              icon: const Icon(Icons.search)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onSubmitted: widget.onCompleted,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
