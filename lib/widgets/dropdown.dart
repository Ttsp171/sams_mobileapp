import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final List dropDownData;
  final bool isRequired;
  final ValueChanged onChanged;
  final Function getValue;

  const CustomDropDown(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.initialValue,
      required this.dropDownData,
      required this.isRequired,
      required this.onChanged,
      required this.getValue});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? initialValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                widget.labelText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
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
            decoration: const BoxDecoration(color: Colors.white),
            child: ButtonTheme(
              alignedDropdown: false,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  focusColor: Colors.blue,
                  isExpanded: true,
                  value: initialValue,
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      widget.hintText,
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      initialValue = val;
                    });
                    widget.onChanged(val);
                  },
                  items: widget.dropDownData.map<DropdownMenuItem>((data) {
                    return DropdownMenuItem(
                      value: data,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          '${widget.getValue(data)}',
                          style: TextStyle(
                            color: data == initialValue
                                ? Colors.black
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          softWrap: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
