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

class FMTicketView extends StatefulWidget {
  const FMTicketView({super.key});

  @override
  State<FMTicketView> createState() => _FMTicketViewState();
}

class _FMTicketViewState extends State<FMTicketView> {
  List normalTickets = [], searchNormalTickets = [];
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNormalTicketsData();
  }

  getNormalTicketsData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res =
        await HttpServices().getWithToken('/api/get-tickets?type=1', context);
    if (res["status"] == 200) {
      setState(() {
        normalTickets.addAll(res["data"]["data"]);
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
    //   searchNormalTickets = [];
    // });
    // for (var i in normalTickets) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchNormalTickets.addAll(i);
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
  //       searchNormalTickets.addAll(res["data"]["data"]["data"]);
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
      // getNormalTicketsData();
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
        title: const Text('Ticketing Dashboard',
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
                            //     searchNormalTickets = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchNormalTickets.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchNormalTickets.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': searchNormalTickets[index]
                                                ["propertyOwnerId"] ??
                                            "",
                                        'Name': searchNormalTickets[index]
                                                ["propertyName"] ??
                                            "",
                                        'Created Date':
                                            searchNormalTickets[index]
                                                    ["buildingName"] ??
                                                "",
                                        'Building Number':
                                            searchNormalTickets[index]
                                                    ["unitName"] ??
                                                "",
                                        'Room Number':
                                            searchNormalTickets[index]
                                                    ["address"] ??
                                                "",
                                        'Subject': searchNormalTickets[index]
                                                ["type"] ??
                                            "",
                                        'Message': searchNormalTickets[index]
                                                ["availableDate"] ??
                                            "",
                                        'Status': searchNormalTickets[index]
                                                ["address"] ??
                                            "",
                                        'Completed Date':
                                            searchNormalTickets[index]
                                                    ["address"] ??
                                                "",
                                        'Attachment': searchNormalTickets[index]
                                                ["address"] ??
                                            "",
                                      },
                                      isBottomButton: true,
                                    );
                                  },
                                ),
                              )
                            : searchNormalTickets.isEmpty &&
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
                                      itemCount: normalTickets.length,
                                      itemBuilder: (context, index) {
                                        return CardContainer(
                                          height: 260,
                                          datas: {
                                            'S. No': index + 1,
                                            'Name': normalTickets[index]
                                                    ["employee_name"] ??
                                                "",
                                            'Created Date':
                                                formatDateToDDMMYYYYHHMMString(
                                                    normalTickets[index]
                                                            ["created_at"]
                                                        .toString()),
                                            'Building Number':
                                                normalTickets[index]
                                                        ["building_no"] ??
                                                    "",
                                            'Room Number': normalTickets[index]
                                                    ["room_number"] ??
                                                "",
                                            'Subject': normalTickets[index]
                                                    ["subject"] ??
                                                "",
                                            'Message': normalTickets[index]
                                                    ["message"] ??
                                                "",
                                            'Status': normalTickets[index]
                                                    ["status"] ??
                                                "",
                                            'Completed Date':
                                                formatDateToDDMMYYYYHHMMString(
                                                    normalTickets[index]
                                                            ["completed_date"]
                                                        .toString()),
                                            'Attachment': normalTickets[index]
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
