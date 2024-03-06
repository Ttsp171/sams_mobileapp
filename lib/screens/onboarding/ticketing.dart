import 'package:flutter/material.dart';
import 'package:sams/controllers/file_pick_controllers.dart';
import 'package:sams/widgets/dropdown.dart';
import 'package:sams/widgets/file_choose.dart';
import 'package:sams/widgets/textfield.dart';

import '../../utils/strings.dart';
import '../../widgets/buttons.dart';

class RegisterTicketing extends StatefulWidget {
  const RegisterTicketing({super.key});

  @override
  State<RegisterTicketing> createState() => _RegisterTicketingState();
}

class _RegisterTicketingState extends State<RegisterTicketing> {
  String fileName = "No File Choosen";

  chooseFile() async {
    var picked = await pickFile();
    if (picked != null) {
      setState(() {
        fileName = picked[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.03),
                  child: const Text(
                    Strings.ticketingWelcomeText,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              CustomTextFieldWithLabel(
                  labelText: 'Employee Name:',
                  required: true,
                  hintText: "Enter Employee Name",
                  onChanged: (val) {}),
              CustomTextFieldWithLabel(
                  labelText: 'Contact No:',
                  required: true,
                  hintText: "Enter Contact No",
                  onChanged: (val) {}),
              CustomDropDown(
                  labelText: "Company:",
                  hintText: "Please Select Company",
                  dropDownData: const ["Seldom", "Test", "Test1"],
                  isRequired: true,
                  onChanged: (val) {},
                  getValue: (associate) => associate),
              CustomDropDown(
                  labelText: "City:",
                  hintText: "Please Select City",
                  dropDownData: const ["Doha", "Ajman", "Riyadh"],
                  isRequired: true,
                  onChanged: (val) {},
                  getValue: (associate) => associate),
              CustomDropDown(
                  labelText: "Building No:",
                  hintText: "Please Select Building",
                  dropDownData: const ["Build 1", "Build 2", "Build 3"],
                  isRequired: true,
                  onChanged: (val) {},
                  getValue: (associate) => associate),
              CustomDropDown(
                  labelText: "Room Number:",
                  hintText: "Please Select Room Number",
                  dropDownData: const ["Room 1", "Room 2", "Room 3"],
                  isRequired: true,
                  onChanged: (val) {},
                  getValue: (associate) => associate),
              CustomDropDown(
                  labelText: "Subject:",
                  hintText: "Please Select Subject",
                  dropDownData: const ["Subject 1", "Subject 2", "Subject 3"],
                  isRequired: true,
                  onChanged: (val) {},
                  getValue: (associate) => associate),
              CustomFilePicker(
                  labelText: "Upload File:",
                  uploadText: "Choose file",
                  fileText: fileName,
                  onPressed: () {
                    chooseFile();
                  },
                  isRequired: false),
              CustomTextFieldWithLabel(
                  labelText: 'Subject',
                  required: false,
                  hintText: "Please enter Subject",
                  onChanged: (val) {}),
              SizedBox(
                height: height * 0.10,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: customButtomwithSize("Save Data", () {}, height * 0.05,
            width * 0.85, Colors.white, Colors.purple, false),
      ),
    );
  }
}
