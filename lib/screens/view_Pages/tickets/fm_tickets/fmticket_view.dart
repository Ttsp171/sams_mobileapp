import 'package:flutter/material.dart';
import 'package:sams/controllers/datetime_controller.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/view_Pages/tickets/edit_tickets.dart';
import 'package:sams/widgets/card.dart';

import '../../../../services/api.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/shimmer.dart';
import '../../../../widgets/textfield.dart';
import '../../../../widgets/toast.dart';
import '../add_tickets.dart';

class FMTicketView extends StatefulWidget {
  const FMTicketView({super.key});

  @override
  State<FMTicketView> createState() => _FMTicketViewState();
}

class _FMTicketViewState extends State<FMTicketView> {
  List normalTickets = [], searchNormalTickets = [];
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
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
    final res = await HttpServices().getWithToken(
        '/api/get-tickets?type=1&per_page=10&page=$currentPage', context);
    if (res["status"] == 200) {
      setState(() {
        normalTickets.addAll(res["data"]["original"]["data"]["data"]);
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
        notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        isNextPage) {
      getNormalTicketsData();
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
        normalTickets.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      showToast("Something went wrong");
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.save,
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
                                      bottomClickData: {
                                        "onLeftLabel": "Edit",
                                        "onRightLabel": "Delete",
                                        "onLeftClick": () {
                                          navigateWithRoute(
                                              context,
                                              EditTickets(
                                                  ticketData:
                                                      searchNormalTickets[
                                                          index]));
                                        },
                                        "onRightClick": () {
                                          deleteTicket(
                                              searchNormalTickets[index]
                                                  ["employee_name"]["id"],
                                              index);
                                        }
                                      }, context: context,
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
                                : normalTickets.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Tickets Found",
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
                                                'Room Number':
                                                    normalTickets[index]
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
                                                        normalTickets[index][
                                                                "completed_date"]
                                                            .toString()),
                                                'Attachment':
                                                    normalTickets[index]
                                                            ["attechment"] ??
                                                        "",
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  navigateWithRoute(
                                                      context,
                                                      EditTickets(
                                                          ticketData:
                                                              normalTickets[
                                                                  index]));
                                                },
                                                "onRightClick": () {
                                                  deleteTicket(
                                                      normalTickets[index]
                                                          ["id"],
                                                      index);
                                                }
                                              }, context: context,
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
