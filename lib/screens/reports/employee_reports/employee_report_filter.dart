import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/widgets/common_widget.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dropdown.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';
import 'employee_report_detail.dart';

class EmployeeReportFilter extends StatefulWidget {
  const EmployeeReportFilter({super.key});

  @override
  State<EmployeeReportFilter> createState() => _EmployeeReportFilterState();
}

class _EmployeeReportFilterState extends State<EmployeeReportFilter> {
  bool showButton = false;
  List companyDropDown = [],
      companyDropDownValues = [],
      projectDropDown = [],
      projectDropDownValues = [],
      employeeNationalityDropDown = [],
      employeeNationalityDropDownValues = [],
      employeeTypeDropDown = [],
      employeeTypeDropDownValues = [],
      otherDropDown = [],
      otherDropDownValues = [];

  String employeeId = "",
      companyName = "",
      projectName = "",
      nationality = "",
      employeeType = "",
      govDocType = "",
      govDocId = "",
      startDate = "",
      endDate = "",
      otherFilt = "";

  @override
  void initState() {
    super.initState();
    getCommonData();
  }

  getCommonData() async {
    final res = await HttpServices().getWithToken("/api/common-data", context);
    if (res["status"] == 200) {
      setState(() {
        employeeNationalityDropDown = res["data"]["data"]["nationality"];
        employeeNationalityDropDownValues = res["data"]["data"]["nationality"];
        otherDropDown = res["data"]["data"]["other_filters"];
      });
      for (var other in otherDropDown) {
        other.forEach((key, value) {
          setState(() {
            otherDropDownValues.add(value);
          });
        });
      }
    } else {
      showToast("Something went Wrong in Common");
    }
  }

  getReportsData(context) async {
    var endpointCustom =
        "${employeeId == "" ? "" : "&employeeId=$employeeId"}${companyName == "" ? "" : "&company=$companyName"}${projectName == "" ? "" : "&project=$projectName"}${employeeType == "" ? "" : "&employee_type=$employeeType"}${govDocId == "" ? "" : "&gov_doc_id=$govDocId"}${govDocType == "" ? "" : "&gov_doc_type=$govDocType"}${startDate == "" ? "" : "&start_date=$startDate"}${endDate == "" ? "" : "&end_date=$endDate"}${otherFilt == "" ? "" : "&other_filters=$otherFilt"}${nationality == "" ? "" : "&nationality=$nationality"}";
    final res = await HttpServices().getWithToken(
        "/api/get-employee-reports?type=1${endpointCustom == "" ? "" : endpointCustom}",
        context);
    if (res["status"] == 200) {
      setState(() {
        showButton = false;
      });
      print(res["data"]["data"]);
      navigateWithRoute(
          context,
          EmployeeReport(
              customUrl: endpointCustom, reportData: res["data"]["data"]));
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      appBar: AppBar(
        title: const Text('Get Employee Reports',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: ColorTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFieldWithLabel(
                    initialValue: employeeId,
                    labelText: 'Employee Name:',
                    required: false,
                    hintText: "Enter employee Id",
                    onChanged: (val) {
                      setState(() {
                        employeeId = val;
                      });
                    }),
                CustomDropDown(
                    labelText: "Company:",
                    hintText: "All Companies",
                    dropDownData: companyDropDownValues,
                    isRequired: false,
                    onChanged: (val) {},
                    getValue: (associate) => associate),
                CustomDropDown(
                    labelText: "Project:",
                    hintText: "All Projects",
                    dropDownData: projectDropDownValues,
                    isRequired: false,
                    onChanged: (val) {},
                    getValue: (associate) => associate),
                CustomDropDown(
                    labelText: "Employee Nationality:",
                    hintText: "Select Nationality",
                    dropDownData: employeeNationalityDropDownValues,
                    isRequired: false,
                    onChanged: (val) {
                      setState(() {
                        nationality = val;
                      });
                    },
                    getValue: (associate) => associate),
                CustomDropDown(
                    labelText: "Employee Type:",
                    hintText: "All Types",
                    dropDownData: projectDropDownValues,
                    isRequired: false,
                    onChanged: (val) {
                      setState(() {
                        employeeType = val;
                      });
                    },
                    getValue: (associate) => associate),
                CustomTextFieldWithLabel(
                    initialValue: govDocType,
                    labelText: 'Government Doc Type:',
                    required: false,
                    hintText: "Enter Gov Doc Type",
                    onChanged: (val) {
                      setState(() {
                        govDocType = val;
                      });
                    }),
                CustomTextFieldWithLabel(
                    initialValue: govDocId,
                    labelText: 'Government Doc ID:',
                    required: false,
                    hintText: "Enter Gov Doc ID",
                    onChanged: (val) {
                      setState(() {
                        govDocId = val;
                      });
                    }),
                DateTimeField(
                    labelText: "Start Date:",
                    hintText: "DD/MM/YYYY",
                    onChanged: (val) {
                      setState(() {
                        startDate = val.toString();
                      });
                    },
                    isRequired: false),
                DateTimeField(
                    labelText: "End Date:",
                    hintText: "DD/MM/YYYY",
                    onChanged: (val) {
                      setState(() {
                        endDate = val.toString();
                      });
                    },
                    isRequired: false),
                CustomDropDown(
                    labelText: "Other Filters:",
                    hintText: "Other Filters",
                    dropDownData: otherDropDownValues,
                    isRequired: false,
                    onChanged: (val) {
                      setState(() {
                        otherFilt = val;
                      });
                    },
                    getValue: (associate) => associate),
                SizedBox(
                  height: h * 0.07,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: customButtonWithSize("Filter", () {
        setState(() {
          showButton = true;
        });
        getReportsData(context);
      }, h * 0.05, w * 0.85, Colors.white, Colors.purple, showButton),
    );
  }
}
