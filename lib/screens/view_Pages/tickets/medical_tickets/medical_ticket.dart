import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sams/controllers/datetime_controller.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/onboarding/ticketing.dart';
import 'package:sams/utils/colors.dart';
import 'package:sams/widgets/card.dart';

import '../../../../services/api.dart';
import '../../../../widgets/shimmer.dart';
import '../../../../widgets/textfield.dart';
import '../../../../widgets/toast.dart';

class MedicalTicketView extends StatefulWidget {
  const MedicalTicketView({super.key});

  @override
  State<MedicalTicketView> createState() => _MedicalTicketViewState();
}

class _MedicalTicketViewState extends State<MedicalTicketView> {
  List medicalTickets = [], searchMedicalTickets = [];
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getmedicalTicketsData();
  }

  getmedicalTicketsData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res =
        await HttpServices().getWithToken('/api/get-tickets?type=2', context);
    if (res["status"] == 200) {
      setState(() {
        medicalTickets.addAll(res["data"]["data"]);
        currentPage++;
        isLoading = false;
        _show = false;
        isFirstTime = false;
      });
    } else {
      setState(() {
        _show = false;
        isFirstTime = false;
      });
      showToast(res["data"]["message"]);
    }
  }

  searchVacantProperty(keyword) async {
    // setState(() {
    //   searchMedicalTickets = [];
    // });
    // for (var i in medicalTickets) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchMedicalTickets.addAll(i);
    //     } else {
    //       setState(() {
    //         _show = false;
    //       });
    //       showToast("No Search Results Found");
    //     }
    //   });
  }
  // final res = await HttpServices().post(
  //     '/api/v1/leasingtenants-ms/leases/vacant-properties?keyword=$keyword&page=1&size=50',
  //     context);
  // if (res["status"] == 200) {
  //   setState(() {
  //     _show = false;
  //   });
  //   if (res["data"]["data"]["data"].isEmpty) {
  //   } else {
  //     setState(() {
  //       searchMedicalTickets.addAll(res["data"]["data"]["data"]);
  //     });
  //   }
  // } else {
  //   setState(() {
  //     _show = false;
  //   });
  //   showToast(res["data"]["message"]);
  // }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      // getmedicalTicketsData();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Ticketing Dashboard',
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
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: _show
                ? const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: ShimmerContainerCards(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SearchFieldWithIcon(
                          hintText: "Search...",
                          width: 350,
                          controller: _searchController,
                          onCompleted: (val) {
                            // if (val != "") {
                            //   setState(() {
                            //     _show = true;
                            //   });
                            //   searchVacantProperty(val);
                            // } else {
                            //   showToast("Enter Keyword to Search");
                            // }
                          },
                          onChanged: (val) {
                            // if (val == "") {
                            //   setState(() {
                            //     searchMedicalTickets = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchMedicalTickets.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchMedicalTickets.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': searchMedicalTickets[index]
                                                ["propertyOwnerId"] ??
                                            "",
                                        'Name': searchMedicalTickets[index]
                                                ["propertyName"] ??
                                            "",
                                        'Created Date':
                                            searchMedicalTickets[index]
                                                    ["buildingName"] ??
                                                "",
                                        'Building Number':
                                            searchMedicalTickets[index]
                                                    ["unitName"] ??
                                                "",
                                        'Room Number':
                                            searchMedicalTickets[index]
                                                    ["address"] ??
                                                "",
                                        'Subject': searchMedicalTickets[index]
                                                ["type"] ??
                                            "",
                                        'Message': searchMedicalTickets[index]
                                                ["availableDate"] ??
                                            "",
                                        'Status': searchMedicalTickets[index]
                                                ["address"] ??
                                            "",
                                        'Completed Date':
                                            searchMedicalTickets[index]
                                                    ["address"] ??
                                                "",
                                        'Attachment':
                                            searchMedicalTickets[index]
                                                    ["address"] ??
                                                "",
                                      },
                                      isBottomButton: true,
                                    );
                                  },
                                ),
                              )
                            : searchMedicalTickets.isEmpty &&
                                    _searchController.text.isNotEmpty &&
                                    !_show
                                ? const Expanded(
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "No Search Results Found",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: medicalTickets.length,
                                      itemBuilder: (context, index) {
                                        return CardContainer(
                                          height: 260,
                                          datas: {
                                            'S. No': index + 1,
                                            'Name': medicalTickets[index]
                                                    ["employee_name"] ??
                                                "",
                                            'Created Date':
                                                formatDateToDDMMYYYYHHMMString(
                                                    medicalTickets[index]
                                                            ["created_at"]
                                                        .toString()),
                                            'Building Number':
                                                medicalTickets[index]
                                                        ["building_no"] ??
                                                    "",
                                            'Room Number': medicalTickets[index]
                                                    ["room_number"] ??
                                                "",
                                            'Subject': medicalTickets[index]
                                                    ["subject"] ??
                                                "",
                                            'Message': medicalTickets[index]
                                                    ["message"] ??
                                                "",
                                            'Status': medicalTickets[index]
                                                    ["status"] ??
                                                "",
                                            'Completed Date':
                                                formatDateToDDMMYYYYHHMMString(
                                                    medicalTickets[index]
                                                            ["completed_date"]
                                                        .toString()),
                                            'Attachment': medicalTickets[index]
                                                    ["attechment"] ??
                                                "",
                                          },
                                          isBottomButton: true,
                                        );
                                      },
                                    ),
                                  ),
                        if (isLoading && !isFirstTime)
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: ColorTheme.primaryColor,
        foregroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        elevation: 8.0,
        shape: const CircleBorder(),
        children: [
          // for (var buttonData in _buttons)
          SpeedDialChild(
            child: const Icon(Icons.new_label),
            backgroundColor: ColorTheme.backgroundColor,
            label: "Add New Ticket",
            labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
            onTap: () {
              navigateWithRoute(context, const RegisterTicketing(userData: {}));
            },
            onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
        ],
      ),
    );
  }
}
