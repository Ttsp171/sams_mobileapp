import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sams/config/env.dart';

import '../../../controllers/datetime_controller.dart';
import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/card.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';

class BuildingLogDetails extends StatefulWidget {
  const BuildingLogDetails({super.key});

  @override
  State<BuildingLogDetails> createState() => _BuildingLogDetailsState();
}

class _BuildingLogDetailsState extends State<BuildingLogDetails> {
  List buildingLogs = [], searchBuildingLogs = [];
  bool showSave = true,
      downloading = false,
      isLoading = false,
      isFirstTime = true,
      _show = true;
  String downloadMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBuildingLog();
  }

  getBuildingLog() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res =
        await HttpServices().getWithToken('/api/get-buildinglog-list', context);
    if (res["status"] == 200) {
      setState(() {
        buildingLogs.addAll(res["data"]["data"]);
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

  getCSVDownloadLink() async {
    setState(() {
      showSave = false;
    });
    final res =
        await HttpServices().getWithToken('/api/export-building-log', context);
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

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      // getBuildingLogs();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Building Log Dashboard',
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
          ),
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
                            //     searchBuildingLogs = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchBuildingLogs.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchBuildingLogs.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': searchBuildingLogs[index]
                                                ["propertyOwnerId"] ??
                                            "",
                                        'Name': searchBuildingLogs[index]
                                                ["propertyName"] ??
                                            "",
                                        'Created Date':
                                            searchBuildingLogs[index]
                                                    ["buildingName"] ??
                                                "",
                                        'Building Number':
                                            searchBuildingLogs[index]
                                                    ["unitName"] ??
                                                "",
                                        'Room Number': searchBuildingLogs[index]
                                                ["address"] ??
                                            "",
                                        'Subject': searchBuildingLogs[index]
                                                ["type"] ??
                                            "",
                                        'Message': searchBuildingLogs[index]
                                                ["availableDate"] ??
                                            "",
                                        'Status': searchBuildingLogs[index]
                                                ["address"] ??
                                            "",
                                        'Completed Date':
                                            searchBuildingLogs[index]
                                                    ["address"] ??
                                                "",
                                        'Attachment': searchBuildingLogs[index]
                                                ["address"] ??
                                            "",
                                      },
                                      isBottomButton: true,
                                      bottomClickData: {
                                        "onLeftLabel": "Edit",
                                        "onRightLabel": "Delete",
                                        "onLeftClick": () {},
                                        "onRightClick": () {}
                                      },
                                      context: context,
                                    );
                                  },
                                ),
                              )
                            : searchBuildingLogs.isEmpty &&
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
                                : buildingLogs.isEmpty
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
                                          itemCount: buildingLogs.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Building Numbers':
                                                    buildingLogs[index]
                                                            ["building_no"] ??
                                                        "",
                                                'Building Type':
                                                    buildingLogs[index]
                                                            ["building_type"] ??
                                                        "",
                                                'No of Rooms':
                                                    buildingLogs[index]
                                                            ["total_rooms"] ??
                                                        "",
                                                'Capacity': buildingLogs[index]
                                                        ["total_beds_sum"] ??
                                                    "",
                                                'Property': buildingLogs[index]
                                                        ["property"] ??
                                                    "",
                                                'City': buildingLogs[index]
                                                        ["message"] ??
                                                    "",
                                                'PO Number': buildingLogs[index]
                                                        ["po_no"] ??
                                                    "",
                                                'Attachment': buildingLogs[
                                                                index]
                                                            ["upload_file"] ==
                                                        null
                                                    ? ""
                                                    : "${Env().baseUrl}/public/${buildingLogs[index]["upload_file"]}",
                                                'Price': buildingLogs[index]
                                                        ["price"] ??
                                                    "",
                                                'Room Prefix':
                                                    buildingLogs[index]
                                                            ["room_prefix"] ??
                                                        "",
                                                'From': buildingLogs[index]
                                                        ["from_date"] ??
                                                    "",
                                                'To': buildingLogs[index]
                                                        ["to_date"] ??
                                                    "",
                                                'Payment Status':
                                                    buildingLogs[index]
                                                            ["payment_status"] ??
                                                        "",
                                                'Payment Type':
                                                    buildingLogs[index]
                                                            ["payment_type"] ??
                                                        "",
                                                'Installment':
                                                    buildingLogs[index]
                                                            ["installments_sum_amount"] ??
                                                        ""
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {},
                                                "onRightClick": () {}
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
        onPressed: () {},
        backgroundColor: ColorTheme.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
