import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../controllers/file_pick_controllers.dart';
import '../../../services/api.dart';
import '../../../utils/strings.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dropdown.dart';
import '../../../widgets/file_choose.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';

class AddTickets extends StatefulWidget {
  const AddTickets({super.key});

  @override
  State<AddTickets> createState() => _AddTicketsState();
}

class _AddTicketsState extends State<AddTickets> {
  bool showButton = false, showLoader = true;
  String fileName = "No File Choosen";
  String? companyName;
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
      statusDropDown = [],
      statusDropDownValue = [],
      attachment = [];

  String? employeeError,
      contactError,
      companyError,
      cityError,
      buildingError,
      roomError,
      messageError,
      subjectError,
      statusError;

  String employeeName = "",
      contactNo = "",
      subject = "",
      status = "",
      message = "";

  int? buildingId, roomId, cityId, companyId;

  @override
  void initState() {
    super.initState();
    getAllData(context);
  }

  getAllData(context) async {
    await getDropDownData('/api/get-fmticket-company', "company", context);
    await getDropDownData('/api/get-fmticket-subject', "subject", context);
    // await getDropDownData('/api/common-data', "status", context);
    await getStatusValues();
    setState(() {
      showLoader = false;
    });
  }

  getStatusValues() async {
    final res = await HttpServices().getWithToken("/api/common-data", context);
    if (res["status"] == 200) {
      setState(() {
        statusDropDown = res["data"]["data"]["ticketing_status"];
      });
      for (var stat in res["data"]["data"]["ticketing_status"]) {
        stat.forEach((key, value) {
          setState(() {
            statusDropDownValue.add(value);
          });
        });
      }
    } else {
      showToast("Something went Wrong in status");
    }
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
          if (company["company_name"] != null) {
            setState(() {
              companyDropDownValues.add(company["company_name"].toString());
            });
          }
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
      // if (field == "status") {
      //   setState(() {
      //     statusDropDown = res["data"]["data"]["ticketing_status"];
      //   });
      //   for (var stat in res["data"]["data"]["ticketing_status"]) {
      //     stat.forEach((key, value) {
      //       setState(() {
      //         statusDropDownValue.add(value);
      //       });
      //     });
      //   }
      // }
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

  validateStatus() {
    if (status == "") {
      setState(() {
        statusError = "Field is Required";
      });
    } else {
      setState(() {
        statusError = null;
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
    validateStatus();
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
        statusError == null &&
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
        '/api/add-update-tickets',
        {
          'employee_name': employeeName,
          'contact_no': contactNo,
          'building_id': buildingId.toString(),
          'room_id': roomId.toString(),
          'subject': subject,
          'city_id': cityId.toString(),
          'message': message.toString(),
          'company_id': companyId.toString(),
          'status': status.toString()
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
    return showLoader
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
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
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    CustomTextFieldWithLabel(
                        initialValue: employeeName,
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
                        initialValue: contactNo,
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
                        initialValue: companyName,
                        errorText: companyError,
                        labelText: "Company:",
                        hintText: "Please Select Company",
                        dropDownData: companyDropDownValues,
                        isRequired: true,
                        onChanged: (val) {
                          var companyIndex = companyDropDownValues.indexOf(val);
                          setState(() {
                            companyId =
                                companyDropDown[companyIndex]["Company_ID"];
                            companyName =
                                companyDropDown[companyIndex]["company_name"];
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
                          var buildingIndex =
                              buildingDropDownValues.indexOf(val);
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
                        fileText:
                            attachment.isNotEmpty ? attachment[1] : fileName,
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
                    CustomDropDown(
                        errorText: statusError,
                        labelText: "Status:",
                        hintText: "Please Select Status",
                        dropDownData: statusDropDownValue,
                        isRequired: true,
                        onChanged: (val) {
                          setState(() {
                            status = val;
                          });
                          validateStatus();
                        },
                        getValue: (associate) => associate),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: customButtonWithSize("Save Data", () {
                        setState(() {
                          showButton = true;
                          submitForm();
                        });
                      }, height * 0.05, width * 0.85, Colors.white,
                          Colors.purple, showButton),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
