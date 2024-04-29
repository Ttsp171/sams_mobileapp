import 'package:flutter/material.dart';
import 'package:sams/widgets/dropdown.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/alert_dailog.dart';
import '../../../widgets/toast.dart';

class RoomArrangement extends StatefulWidget {
  const RoomArrangement({super.key});

  @override
  State<RoomArrangement> createState() => _RoomArrangementState();
}

class _RoomArrangementState extends State<RoomArrangement> {
  List buildingDropDown = [], buildingDropDownValues = [], roomDatas = [];
  String buildingName = "", buildingId = "", roomCount = "", bedCount = "";
  bool showData = false, showLoad = false;
  String? roomErrorText;

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

  getDatas() async {
    final res = await HttpServices()
        .getWithToken('/api/get-room-list?building_id=$buildingId', context);
    if (res["status"] == 200) {
      setState(() {
        roomDatas = res["data"]["data"]["room_details"];
        showData = true;
        showLoad = false;
      });
    } else {}
  }

  deleteRoom(roomId) async {
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/room-bed-action', {'type': '2', 'action_id': roomId.toString()});
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
    final res =
        await HttpServices().postWIthTokenAndBody('/api/room-bed-action', {
      'type': '1',
      'action_id': buildingId.toString(),
      'room_count': roomCount,
      'bed_count': bedCount
    });
    if (res["status"] == 200) {
      setState(() {
        roomCount = "";
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
                      errorText: roomErrorText,
                      labelText: "Room Arrangement",
                      hintText: "Select Building",
                      dropDownData: buildingDropDownValues,
                      isRequired: true,
                      onChanged: (val) {
                        var index = buildingDropDownValues.indexOf(val);
                        setState(() {
                          showLoad = true;
                          showData = false;
                          buildingId = buildingDropDown[index]["id"].toString();
                          buildingName = val.toString();
                        });
                        getDatas();
                      },
                      getValue: (associate) => associate),
                ),
                if (showData)
                  Expanded(
                    child: ListView.builder(
                        itemCount: roomDatas.length,
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
                                  roomDatas[index]["order_room"].toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                            leading: Text(roomDatas[index]["room_name"]),
                            trailing: IconButton(
                                onPressed: () {
                                  deleteRoom(roomDatas[index]["id"]);
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
                  roomCount = "";
                  bedCount = "";
                });
                showTwoTextFieldAlert(
                    "Add Room",
                    "Room Count",
                    "",
                    roomCount,
                    (val) {
                      setState(() {
                        roomCount = val;
                      });
                    },
                    "Bed Count",
                    "",
                    bedCount,
                    (val) {
                      setState(() {
                        bedCount = val;
                      });
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
