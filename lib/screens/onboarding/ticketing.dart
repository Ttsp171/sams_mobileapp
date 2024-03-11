import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sams/controllers/file_pick_controllers.dart';
import 'package:sams/services/api.dart';
import 'package:sams/widgets/dropdown.dart';
import 'package:sams/widgets/file_choose.dart';
import 'package:sams/widgets/textfield.dart';
import 'package:sams/widgets/toast.dart';

import '../../utils/strings.dart';
import '../../widgets/buttons.dart';

class RegisterTicketing extends StatefulWidget {
  const RegisterTicketing({super.key});

  @override
  State<RegisterTicketing> createState() => _RegisterTicketingState();
}

class _RegisterTicketingState extends State<RegisterTicketing> {
  bool showButton = false;
  String fileName = "No File Choosen";
  List companyDropDown = [],
      companyDropDownValues = [],
      cityDropDown = [],
      cityDropDownValues = [],
      buildingDropDown = [],
      buildingDropDownValues = [],
      roomDropDown = [],
      roomDropDownValues = [],
      subjectDropDown = [],
      subjectDropDownValues = [],
      attachment = [];

  String? employeeError,
      contactError,
      companyError,
      cityError,
      buildingError,
      roomError,
      messageError,
      subjectError;

  String employeeName = "", contactNo = "", subject = "", message = "";

  int? buildingId, roomId, cityId, companyId;

  @override
  void initState() {
    super.initState();
    getDropDownData('/api/get-fmticket-company', "company", context);
    getDropDownData('/api/get-fmticket-subject', "subject", context);
  }

  getDropDownData(endpoint, field, context) async {
    final res = await HttpServices().get(endpoint, context);
    if (res["status"] == 200) {
      if (field == "company") {
        setState(() {
          companyDropDown = res["data"]["data"];
        });
        subjectDropDown = res["data"]["data"];

        for (var company in res["data"]["data"]) {
          setState(() {
            companyDropDownValues.add(company["company_name"]);
          });
        }
      }
      if (field == "city") {
        setState(() {
          cityDropDown = res["data"]["data"];
        });
        for (var city in res["data"]["data"]) {
          setState(() {
            cityDropDownValues.add(city["name"]);
          });
        }
      }
      if (field == "building") {
        setState(() {
          buildingDropDown = res["data"]["data"];
        });
        for (var building in res["data"]["data"]) {
          setState(() {
            buildingDropDownValues.add(building["building_no"]);
          });
        }
      }
      if (field == "room") {
        setState(() {
          roomDropDown = res["data"]["data"];
        });
        for (var room in res["data"]["data"]) {
          setState(() {
            roomDropDownValues.add(room["order_room"]);
          });
        }
      }
      if (field == "subject") {
        setState(() {
          subjectDropDown = res["data"]["data"];
        });
        for (var subject in res["data"]["data"]) {
          subject.forEach((key, value) {
            setState(() {
              subjectDropDownValues.add(value);
            });
          });
        }
      }
    } else {
      showToast("Something went Wrong in $field");
    }
  }

  chooseFile() async {
    var picked = await pickFile();
    if (picked != null) {
      setState(() {
        attachment = picked;
      });
    }
  }

  validateEmployee() {
    if (employeeName == "") {
      setState(() {
        employeeError = "Field is Required";
      });
    } else {
      setState(() {
        employeeError = null;
      });
    }
  }

  validateContact() {
    if (contactNo == "") {
      setState(() {
        contactError = "Field is Required";
      });
    } else {
      setState(() {
        contactError = null;
      });
    }
  }

  validateCompany() {
    if (companyId == null) {
      setState(() {
        companyError = "Field is Required";
      });
    } else {
      setState(() {
        companyError = null;
      });
    }
  }

  validateCity() {
    if (cityId == null) {
      setState(() {
        cityError = "Field is Required";
      });
    } else {
      setState(() {
        cityError = null;
      });
    }
  }

  validateBuilding() {
    if (buildingId == null) {
      setState(() {
        buildingError = "Field is Required";
      });
    } else {
      setState(() {
        buildingError = null;
      });
    }
  }

  validateRoom() {
    if (roomId == null) {
      setState(() {
        roomError = "Field is Required";
      });
    } else {
      setState(() {
        roomError = null;
      });
    }
  }

  validateSubject() {
    if (subject == "") {
      setState(() {
        subjectError = "Field is Required";
      });
    } else {
      setState(() {
        subjectError = null;
      });
    }
  }

  validateMessage() {
    if (message == "") {
      setState(() {
        messageError = "Field is Required";
      });
    } else {
      setState(() {
        messageError = null;
      });
    }
  }

  validateFields() {
    validateEmployee();
    validateContact();
    validateCompany();
    validateCity();
    validateBuilding();
    validateRoom();
    validateSubject();
    validateMessage();
  }

  Future<void> submitForm() async {
    validateFields();

    if (employeeError == null &&
        contactError == null &&
        companyError == null &&
        cityError == null &&
        buildingError == null &&
        roomError == null &&
        messageError == null &&
        subjectError == null) {
      storeFMTickets(context);
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  storeFMTickets(context) async {
    final res = await HttpServices().postWithAttachments(
        '/api/store-fm-ticket',
        {
          'employee_name': employeeName,
          'contact_no': contactNo,
          'building_id': buildingId.toString(),
          'room_id': roomId.toString(),
          'subject': subject,
          'city_id': cityId.toString(),
          'message': message.toString(),
          'company_id': companyId.toString()
        },
        attachment.isEmpty ? [] : attachment[0]);
    if (res["status"] == 200) {
      setState(() {
        showButton = false;
      });
      var message = json.decode(res["data"]);
      showSuccessToast(message["message"]);
      Navigator.pop(context);
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
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: height * 0.10, bottom: height * 0.05),
                  child: const Text(
                    Strings.ticketingWelcomeText,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              CustomTextFieldWithLabel(
                  errorText: employeeError,
                  labelText: 'Employee Name:',
                  required: true,
                  hintText: "Enter Employee Name",
                  onChanged: (val) {
                    setState(() {
                      employeeName = val;
                    });
                    validateEmployee();
                  }),
              CustomTextFieldWithLabel(
                  errorText: contactError,
                  labelText: 'Contact No:',
                  required: true,
                  hintText: "Enter Contact No",
                  onChanged: (val) {
                    setState(() {
                      contactNo = val;
                    });
                    validateContact();
                  }),
              CustomDropDown(
                  errorText: companyError,
                  labelText: "Company:",
                  hintText: "Please Select Company",
                  dropDownData: companyDropDownValues,
                  isRequired: true,
                  onChanged: (val) {
                    var companyIndex = companyDropDownValues.indexOf(val);
                    setState(() {
                      companyId = companyDropDown[companyIndex]["Company_ID"];
                      cityDropDown = [];
                      cityDropDownValues = [];
                      buildingDropDown = [];
                      buildingDropDownValues = [];
                      roomDropDown = [];
                      roomDropDownValues = [];
                      cityId = null;
                      buildingId = null;
                      roomId = null;
                    });
                    validateCompany();
                    getDropDownData(
                        '/api/get-fmticket-city?company_id=${companyDropDown[companyIndex]["Company_ID"]}',
                        "city",
                        context);
                  },
                  getValue: (associate) => associate),
              CustomDropDown(
                  errorText: cityError,
                  labelText: "City:",
                  hintText: "Please Select City",
                  dropDownData: cityDropDownValues,
                  isRequired: true,
                  onChanged: (val) {
                    var cityIndex = cityDropDownValues.indexOf(val);
                    setState(() {
                      cityId = cityDropDown[cityIndex]["id"];
                      buildingDropDown = [];
                      buildingDropDownValues = [];
                      roomDropDown = [];
                      roomDropDownValues = [];
                      buildingId = null;
                      roomId = null;
                    });
                    validateCity();
                    getDropDownData(
                        '/api/get-fmticket-buildings?city_id=${cityDropDown[cityIndex]["id"]}',
                        "building",
                        context);
                  },
                  getValue: (associate) => associate),
              CustomDropDown(
                  errorText: buildingError,
                  labelText: "Building No:",
                  hintText: "Please Select Building",
                  dropDownData: buildingDropDownValues,
                  isRequired: true,
                  onChanged: (val) {
                    var buildingIndex = buildingDropDownValues.indexOf(val);
                    setState(() {
                      buildingId = buildingDropDown[buildingIndex]["id"];
                      roomDropDown = [];
                      roomDropDownValues = [];
                      roomId = null;
                    });
                    validateBuilding();
                    getDropDownData(
                        '/api/get-fmticket-rooms?building_id=${buildingDropDown[buildingIndex]["id"]}',
                        "room",
                        context);
                  },
                  getValue: (associate) => associate),
              CustomDropDown(
                  errorText: roomError,
                  labelText: "Room Number:",
                  hintText: "Please Select Room Number",
                  dropDownData: roomDropDownValues,
                  isRequired: true,
                  onChanged: (val) {
                    var roomIndex = roomDropDownValues.indexOf(val);
                    setState(() {
                      roomId = roomDropDown[roomIndex]["id"];
                    });
                    validateRoom();
                  },
                  getValue: (associate) => associate),
              CustomDropDown(
                  errorText: subjectError,
                  labelText: "Subject:",
                  hintText: "Please Select Subject",
                  dropDownData: subjectDropDownValues,
                  isRequired: true,
                  onChanged: (val) {
                    setState(() {
                      subject = val;
                    });
                    validateSubject();
                  },
                  getValue: (associate) => associate),
              CustomFilePicker(
                  labelText: "Upload File:",
                  uploadText: "Choose file",
                  fileText: attachment.isNotEmpty ? attachment[1] : fileName,
                  onPressed: () {
                    chooseFile();
                  },
                  isRequired: false),
              CustomTextFieldWithLabel(
                  errorText: messageError,
                  labelText: 'Message',
                  required: true,
                  hintText: "Please enter Message",
                  onChanged: (val) {
                    setState(() {
                      message = val;
                    });
                    validateMessage();
                  }),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: customButtomwithSize("Save Data", () {
                  setState(() {
                    showButton = true;
                    submitForm();
                  });
                }, height * 0.05, width * 0.85, Colors.white, Colors.purple,
                    showButton),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 5),
      //   child: customButtomwithSize("Save Data", () {
      //     setState(() {
      //       showButton = true;
      //       submitForm();
      //     });
      //   }, height * 0.05, width * 0.85, Colors.white, Colors.purple,
      //       showButton),
      // ),
    );
  }
}
