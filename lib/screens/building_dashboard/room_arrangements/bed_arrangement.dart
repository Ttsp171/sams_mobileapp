import 'package:flutter/material.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/alert_dailog.dart';
import '../../../widgets/dropdown.dart';
import '../../../widgets/toast.dart';

class BedArrangement extends StatefulWidget {
  const BedArrangement({super.key});

  @override
  State<BedArrangement> createState() => _BedArrangementState();
}

class _BedArrangementState extends State<BedArrangement> {
  List buildingDropDown = [],
      buildingDropDownValues = [],
      roomDropDown = [],
      roomDropDownValues = [],
      bedDatas = [];
  String buildingName = "",
      buildingId = "",
      roomName = "",
      roomId = "",
      bedCount = "";
  bool showData = false, showLoad = false;
  String? buildingError, roomError;

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

  getRoomData(buildId) async {
    final res = await HttpServices()
        .getWithToken("/api/get-room-list?building_id=$buildId", context);
    if (res["status"] == 200) {
      setState(() {
        roomDropDown = res["data"]["data"]["room_details"];
      });
      for (var build in res["data"]["data"]["room_details"]) {
        setState(() {
          roomDropDownValues.add(build["room_name"]);
        });
      }
    } else {
      showToast("Something went Wrong in Room");
    }
  }

  getDatas() async {
    final res = await HttpServices()
        .getWithToken('/api/get-bed-list?room_id=$roomId', context);
    if (res["status"] == 200) {
      setState(() {
        bedDatas = res["data"]["data"]["bed_details"];
        showData = true;
        showLoad = false;
      });
    } else {}
  }

  deleteRoom(bedId) async {
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/room-bed-action', {'type': '4', 'action_id': bedId.toString()});
    if (res["status"] == 200) {
      showSuccessToast(res["data"]["message"]);
      setState(() {
        showData = false;
        showLoad = true;
      });
      getDatas();
    } else {
      showToast("Something went Wrong");
    }
  }

  addRoom(context) async {
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/room-bed-action',
        {'type': '3', 'action_id': roomId.toString(), 'bed_count': bedCount});
    if (res["status"] == 200) {
      setState(() {
        bedCount = "";
      });
      showSuccessToast(res["data"]["message"]);
      Navigator.pop(context);
      getDatas();
    } else {
      showToast("Something went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomDropDown(
                      errorText: buildingError,
                      labelText: "Bed Arrangement",
                      hintText: "Select Building",
                      dropDownData: buildingDropDownValues,
                      isRequired: true,
                      onChanged: (val) {
                        var index = buildingDropDownValues.indexOf(val);
                        setState(() {
                          buildingId = buildingDropDown[index]["id"].toString();
                          buildingName = val.toString();
                          roomDropDown = [];
                          roomDropDownValues = [];
                          roomId = "";
                          roomName = "";
                        });
                        getRoomData(buildingDropDown[index]["id"].toString());
                      },
                      getValue: (associate) => associate),
                ),
                if (buildingId != "")
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomDropDown(
                        errorText: roomError,
                        labelText: "",
                        hintText: "Select Room",
                        dropDownData: roomDropDownValues,
                        isRequired: false,
                        onChanged: (val) {
                          var index = roomDropDownValues.indexOf(val);
                          setState(() {
                            showLoad = true;
                            showData = false;
                            roomId = roomDropDown[index]["id"].toString();
                            roomName = val.toString();
                          });
                          getDatas();
                        },
                        getValue: (associate) => associate),
                  ),
                if (showData)
                  Expanded(
                    child: ListView.builder(
                        itemCount: bedDatas.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Center(
                                child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 204, 0, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              child: Center(
                                child: Text(
                                  bedDatas[index]["order_bed"].toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                            leading: Text(bedDatas[index]["bed_name"]),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteRoom(bedDatas[index]["id"]);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                )),
                          );
                        }),
                  )
              ],
            ),
          ),
          if (showLoad)
            SizedBox(
              width: w,
              height: h,
              child: const Center(
                  child: Text(
                "Fetching....",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold),
              )),
            )
        ],
      ),
      floatingActionButton: showData
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  bedCount = "";
                });
                showTextFieldAlert(
                    "Add Bed",
                    "Bed Count",
                    bedCount,
                    (val) {
                      bedCount = val.toString();
                    },
                    () {
                      addRoom(context);
                    },
                    "Add",
                    () {
                      Navigator.pop(context);
                    },
                    context);
              },
              backgroundColor: ColorTheme.primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
