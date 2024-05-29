import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sams/services/api.dart';
import 'package:http/http.dart' as http;

import '../../utils/colors.dart';
import '../../widgets/buttons.dart';
import '../../widgets/card.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/toast.dart';

class WareHouseReport extends StatefulWidget {
  const WareHouseReport({super.key});

  @override
  State<WareHouseReport> createState() => _WareHouseReportState();
}

class _WareHouseReportState extends State<WareHouseReport> {
  bool showDownloadButton = false,
      showButton = false,
      showData = false,
      showSave = true,
      downloading = false;
  List wareHouseData = [], wareHouseDropDown = [], wareHouseDropDownValues = [];
  String? dropDownError;
  String selectedHouse = "";
  String selectedHouseId = "";

  @override
  void initState() {
    super.initState();
    getWareHouseList();
  }

  validateWareHouse() {
    if (selectedHouse == "") {
      setState(() {
        dropDownError = "Select the WareHouse City";
      });
    } else {
      setState(() {
        dropDownError = null;
      });
    }
  }

  getCSVPdfDownloadLink(type, cityId) async {
    setState(() {
      showSave = false;
    });
    final res = await HttpServices().getWithToken(
        '/api/get-warehouse-reports?type=$type&warehouse_city_id=$cityId',
        context);
    if (res["status"] == 200) {
      downloadFile(res["data"]["data"]["export_url"],
          "${DateTime.now().toString()}${res["data"]["data"]["file_name"]}");
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

  getWareHouseReport(type, cityId) async {
    validateWareHouse();
    if (dropDownError == null) {
      final res = await HttpServices().getWithToken(
          '/api/get-warehouse-reports?type=$type&warehouse_city_id=$cityId',
          context);
      if (res["status"] == 200) {
        setState(() {
          wareHouseData.addAll(res["data"]["data"]);
          showButton = false;
          showDownloadButton = true;
          showData = true;
        });
      } else {
        showToast("Error Occured");
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

  getWareHouseList() async {
    final res = await HttpServices()
        .getWithToken('/api/warehouse-city-action?type=1', context);
    if (res["status"] == 200) {
      setState(() {
        wareHouseDropDown = res["data"]["data"];
      });
      for (var ware in res["data"]["data"]) {
        setState(() {
          wareHouseDropDownValues.add(ware["name"]);
        });
      }
    } else {}
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 239, 224),
        appBar: AppBar(
          title: const Text('Get Warehouse Reports',
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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: CustomDropDown(
                          errorText: dropDownError,
                          labelText: "Ware House:",
                          hintText: "Please Select Ware House",
                          dropDownData: wareHouseDropDownValues,
                          isRequired: true,
                          onChanged: (val) {
                            var index = wareHouseDropDownValues.indexOf(val);
                            setState(() {
                              selectedHouse = val;
                              selectedHouseId =
                                  wareHouseDropDown[index]["id"].toString();
                            });
                          },
                          getValue: (associate) => associate),
                    ),
                    customButtonWithSize("Get Result", () {
                      setState(() {
                        showButton = true;
                        wareHouseData = [];
                      });
                      getWareHouseReport("1", selectedHouseId);
                    }, h * 0.05, w * 0.85, Colors.white, Colors.purple,
                        showButton),
                    const SizedBox(height: 20),
                    if (showData)
                      wareHouseData.isEmpty
                          ? const Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Reports Found",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: wareHouseData.length,
                                itemBuilder: (context, index) {
                                  return CardContainer(
                                    height: 200,
                                    datas: {
                                      'ID': index + 1,
                                      'Item Code':
                                          wareHouseData[index]["item"] == null
                                              ? ""
                                              : wareHouseData[index]["item"]
                                                  ["item_code"],
                                      'Description':
                                          wareHouseData[index]["item"] == null
                                              ? ""
                                              : wareHouseData[index]["item"]
                                                  ["item_description"],
                                      'Unit':
                                          wareHouseData[index]["units"] ?? "",
                                      'Price':
                                          wareHouseData[index]["price"] ?? "",
                                      'Quantity': wareHouseData[index]
                                              ["quantity"] ??
                                          "",
                                      'Available Quantity': wareHouseData[index]
                                              ["awailable_qty"] ??
                                          "",
                                    },
                                    isBottomButton: false,
                                    context: context,
                                    bottomClickData: const {},
                                  );
                                },
                              ),
                            ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: showDownloadButton && wareHouseData.isNotEmpty
            ? MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Container(
                  width: w * 0.6,
                  height: h * 0.06,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          getCSVPdfDownloadLink("3", selectedHouseId);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            Text('Get PDF')
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getCSVPdfDownloadLink("2", selectedHouseId);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/excel_icon.svg',
                              color: Colors.green,
                              height: 20,
                              width: 20,
                            ),
                            const Text(
                              'Get Excel',
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox());
  }
}
