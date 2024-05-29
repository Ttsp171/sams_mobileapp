import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sams/controllers/datetime_controller.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/utils/colors.dart';
import 'package:sams/widgets/card.dart';
import 'package:http/http.dart' as http;

import '../../../services/api.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';
import '../add_tickets.dart';

class MedicalTicketView extends StatefulWidget {
  const MedicalTicketView({super.key});

  @override
  State<MedicalTicketView> createState() => _MedicalTicketViewState();
}

class _MedicalTicketViewState extends State<MedicalTicketView> {
  List medicalTickets = [], searchMedicalTickets = [];
  int currentPage = 1;
  bool downloading = false;
  String downloadMessage = '';
  bool isLoading = false,
      isFirstTime = true,
      _show = true,
      showSave = true,
      isNextPage = false;
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
    final res = await HttpServices().getWithToken(
        '/api/get-tickets?type=2&per_page=10&page=$currentPage', context);
    if (res["status"] == 200) {
      setState(() {
        medicalTickets.addAll(res["data"]["original"]["data"]["data"]);
        currentPage++;
        isLoading = false;
        _show = false;
        isFirstTime = false;
        isNextPage = res["data"]["original"]["data"]["next_page_url"] == null
            ? false
            : true;
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
        notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        isNextPage) {
      getmedicalTicketsData();
      return true;
    }
    return false;
  }

  deleteTicket(ticketId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/delete-ticket', {'ticket_id': ticketId.toString()});
    if (res["status"] == 200) {
      setState(() {
        medicalTickets.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      showToast("Something went wrong");
    }
  }

  getCSVDownloadLink() async {
    setState(() {
      showSave = false;
    });
    final res =
        await HttpServices().getWithToken('/api/tickets-export', context);
    if (res["status"] == 200) {
      downloadFile(res["data"]["data"]["export_url"],
          "${res["data"]["data"]["file_name"]}${DateTime.now().toString()}.xlsx");
    } else {
      setState(() {
        showSave = true;
      });
      showToast(res["data"]["message"]);
    }
  }

  Future<void> downloadFile(String url, String filename) async {
    setState(() {
      downloading = true;
      // downloadMessage = 'Downloading $filename...';
    });
    showSuccessToast('Downloading $filename');

    final directory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    final filePath = '${directory!.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final sourceFile = File(filePath);

    await sourceFile.writeAsBytes(response.bodyBytes);

    setState(() {
      downloading = false;
      showSave = true;
      // downloadMessage = 'Downloaded $filename';
    });
    showSuccessToast('Downloaded $filename');
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: showSave
                    ? () {
                        getCSVDownloadLink();
                      }
                    : () {},
                icon: Icon(
                  showSave ? Icons.save : Icons.circle_outlined,
                  size: 40,
                  color: Colors.black,
                  weight: BorderSide.strokeAlignOutside,
                )),
          )
        ],
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
                                      bottomClickData: {
                                        "onLeftLabel": "Edit",
                                        "onRightLabel": "Delete",
                                        "onLeftClick": () {},
                                        "onRightClick": () {
                                          deleteTicket(
                                              searchMedicalTickets[index]["id"],
                                              index);
                                        }
                                      },
                                      context: context,
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
                                : medicalTickets.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Medical Tickets Found",
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
                                                'Room Number':
                                                    medicalTickets[index]
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
                                                        medicalTickets[index][
                                                                "completed_date"]
                                                            .toString()),
                                                'Attachment':
                                                    medicalTickets[index]
                                                            ["attechment"] ??
                                                        "",
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {},
                                                "onRightClick": () {
                                                  deleteTicket(
                                                      medicalTickets[index]
                                                          ["id"],
                                                      index);
                                                }
                                              },
                                              context: context,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateWithRoute(context, const AddTickets());
        },
        backgroundColor: ColorTheme.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
