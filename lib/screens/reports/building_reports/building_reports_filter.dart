import 'package:flutter/material.dart';

import '../../../controllers/navigation_controllers.dart';
import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dropdown.dart';
import '../../../widgets/toast.dart';
import 'building_reports_detail.dart';

class BuildingReportFilter extends StatefulWidget {
  const BuildingReportFilter({super.key});

  @override
  State<BuildingReportFilter> createState() => _BuildingReportFilterState();
}

class _BuildingReportFilterState extends State<BuildingReportFilter> {
  bool showButton = false;
  List buildingDropDown = [],
      buildingDropDownValues = [],
      roomDropDown = [],
      roomDropDownValues = [],
      bedDropDown = [],
      bedDropDownValues = [];

  String buildingId = "",
      roomId = "",
      bedId = "",
      buildingName = "",
      roomName = "",
      bedName = "";
  String? buildingError;

  @override
  void initState() {
    super.initState();
    getBuildingData();
  }

  getBuildingData() async {
    final res =
        await HttpServices().getWithToken("/api/get-buildinglog-list", context);
    if (res["status"] == 200) {
      setState(() {
        buildingDropDown = res["data"]["data"];
      });
      for (var build in res["data"]["data"]) {
        setState(() {
          buildingDropDownValues.add(build["building_no"]);
        });
      }
    } else {
      showToast("Something went Wrong in Building");
    }
  }

  getRoomData() async {
    final res = await HttpServices()
        .getWithToken("/api/get-room-list?building_id=$buildingId", context);
    if (res["status"] == 200) {
      setState(() {
        roomDropDown = res["data"]["data"]["room_details"];
      });
      for (var roo in res["data"]["data"]["room_details"]) {
        setState(() {
          roomDropDownValues.add(roo["room_name"]);
        });
      }
    } else {
      showToast("Something went Wrong in Room");
    }
  }

  getBedData() async {
    final res = await HttpServices()
        .getWithToken("/api/get-bed-list?room_id=$roomId", context);
    if (res["status"] == 200) {
      setState(() {
        bedDropDown = res["data"]["data"]["bed_details"];
      });
      for (var be in res["data"]["data"]["bed_details"]) {
        setState(() {
          bedDropDownValues.add(be["bed_name"]);
        });
      }
    } else {
      showToast("Something went Wrong in Building");
    }
  }

  getReportsData(context) async {
    validateBuilding();
    if (buildingError == null) {
      var endpointCustom =
          "${buildingId == "" ? "" : "&building_id=$buildingId"}${roomId == "" ? "" : "&room_id=$roomId"}${bedId == "" ? "" : "&bed_id=$bedId"}";
      final res = await HttpServices().getWithToken(
          "/api/get-building-reports?type=1${endpointCustom == "" ? "" : endpointCustom}",
          context);
      if (res["status"] == 200) {
        setState(() {
          showButton = false;
        });
        navigateWithRoute(
            context,
            BuildingReport(
                customUrl: endpointCustom, reportData: res["data"]["data"]));
      } else {
        setState(() {
          showButton = false;
        });
      }
    } else {
      setState(() {
        showButton = false;
      });
    }
  }

  validateBuilding() {
    if (buildingId == "") {
      setState(() {
        buildingError = "Building is Required";
      });
    } else {
      setState(() {
        buildingError = null;
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
        title: const Text('Get Building Reports',
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
                CustomDropDown(
                    // initialValue: buildingName,
                    errorText: buildingError,
                    labelText: "Building:",
                    hintText: "All Buildings",
                    dropDownData: buildingDropDownValues,
                    isRequired: true,
                    onChanged: (val) {
                      var buildIndex = buildingDropDownValues.indexOf(val);
                      setState(() {
                        buildingId =
                            buildingDropDown[buildIndex]["id"].toString();
                        buildingName = val;
                        bedDropDown = [];
                        bedDropDownValues = [];
                        roomDropDown = [];
                        roomDropDownValues = [];
                        bedId = "";
                        roomId = "";
                        // roomName = "";
                        // bedName = "";
                      });

                      getRoomData();
                    },
                    getValue: (associate) => associate),
                if (buildingId != "")
                  CustomDropDown(
                      // initialValue: roomName,
                      labelText: "Room:",
                      hintText: "All Rooms",
                      dropDownData: roomDropDownValues,
                      isRequired: false,
                      onChanged: (val) {
                        var roomIndex = roomDropDownValues.indexOf(val);
                        setState(() {
                          roomId = roomDropDown[roomIndex]["id"].toString();
                          roomName = val;
                          bedDropDown = [];
                          bedDropDownValues = [];
                          bedId = "";
                          // bedName = "";
                        });

                        getBedData();
                      },
                      getValue: (associate) => associate),
                if (roomId != "")
                  CustomDropDown(
                      // initialValue: bedName,
                      labelText: "Bed:",
                      hintText: "All Beds",
                      dropDownData: bedDropDownValues,
                      isRequired: false,
                      onChanged: (val) {
                        var bedIndex = bedDropDownValues.indexOf(val);
                        setState(() {
                          bedId = bedDropDown[bedIndex]["id"].toString();
                          bedName = val;
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
