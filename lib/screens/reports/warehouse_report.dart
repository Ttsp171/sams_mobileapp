import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams/services/api.dart';

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
  bool showDownloadButton = false, showButton = false, showData = false;
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

  getWareHouseReport(type, cityId) async {
    setState(() {
      wareHouseData.addAll([
        {
          "id": 22,
          "Company_ID": 1,
          "item_id": 7,
          "units": "kgs",
          "quantity": 100,
          "awailable_qty": 60,
          "price": 758,
          "box_qty": null,
          "location": "6",
          "created_at": "2024-02-04T13:36:38.000000Z",
          "updated_at": "2024-02-17T15:15:46.000000Z",
          "item": {
            "id": 7,
            "Company_ID": 1,
            "item_code": "003",
            "item_description": "Blankets",
            "status": 1,
            "created_at": "2023-12-26T14:18:30.000000Z",
            "updated_at": "2023-12-26T14:18:30.000000Z"
          },
          "city": {
            "id": 6,
            "Company_ID": 1,
            "name": "surat",
            "created_at": "2024-01-20T15:35:33.000000Z",
            "updated_at": "2024-01-20T15:35:33.000000Z"
          }
        },
        {
          "id": 21,
          "Company_ID": 1,
          "item_id": 6,
          "units": "pcs",
          "quantity": 100,
          "awailable_qty": 58,
          "price": 452,
          "box_qty": null,
          "location": "6",
          "created_at": "2024-02-04T13:36:20.000000Z",
          "updated_at": "2024-02-17T15:15:41.000000Z",
          "item": {
            "id": 6,
            "Company_ID": 1,
            "item_code": "002",
            "item_description": "Mattresses",
            "status": 1,
            "created_at": "2023-12-26T14:18:18.000000Z",
            "updated_at": "2023-12-26T14:18:18.000000Z"
          },
          "city": {
            "id": 6,
            "Company_ID": 1,
            "name": "surat",
            "created_at": "2024-01-20T15:35:33.000000Z",
            "updated_at": "2024-01-20T15:35:33.000000Z"
          }
        }
      ]);
      showButton = false;
      showDownloadButton = true;
      showData = true;
    });
    // validateWareHouse();
    // if (dropDownError == null) {
    //   final res = await HttpServices().getWithToken(
    //       '/api/get-warehouse-reports?type=$type&warehouse_city_id=$cityId',
    //       context);
    //   if (res["status"] == 200) {
    //     setState(() {
    //       wareHouseData.addAll(res["data"]["data"]);
    //       showButton = false;
    //       showDownloadButton = true;
    //     });
    //   } else {
    //     showToast("Error Occured");
    //     setState(() {
    //       showButton = false;
    //     });
    //   }
    // } else {
    //   setState(() {
    //     showButton = false;
    //   });
    // }
  }

  getWareHouseList() {}

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
                          onChanged: (val) {},
                          getValue: (associate) => associate),
                    ),
                    customButtonWithSize("Get Result", () {
                      setState(() {
                        showButton = true;
                        getWareHouseReport("1", selectedHouseId);
                      });
                    }, h * 0.05, w * 0.85, Colors.white, Colors.purple,
                        showButton),
                    const SizedBox(height: 20),
                    if (showData)
                      Expanded(
                        child: ListView.builder(
                          itemCount: wareHouseData.length,
                          itemBuilder: (context, index) {
                            return CardContainer(
                              height: 260,
                              datas: {
                                'ID': index + 1,
                                'Item Code':
                                    wareHouseData[index]["item"]["item_code"] ?? "",
                                'Description':
                                    wareHouseData[index]["item"]["item_description"] ?? "",
                                'Unit': wareHouseData[index]["units"] ?? "",
                                'Price': wareHouseData[index]["price"] ?? "",
                                'Quantity':
                                    wareHouseData[index]["quantity"] ?? "",
                                'Available Quantity':
                                    wareHouseData[index]["awailable_qty"] ?? "",
                              },
                              isBottomButton: false,
                              context: context,
                              bottomClickData: {},
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // body: Center(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         CustomDropDown(
        //             errorText: dropDownError,
        //             labelText: "Ware House:",
        //             hintText: "Please Select Ware House",
        //             dropDownData: wareHouseDropDownValues,
        //             isRequired: true,
        //             onChanged: (val) {},
        //             getValue: (associate) => associate),
        //         customButtonWithSize("Get Result", () {
        //           setState(() {
        //             showButton = true;
        //             getWareHouseReport("1", selectedHouseId);
        //           });
        //         }, h * 0.05, w * 0.85, Colors.white, Colors.purple, showButton),
        //         Container(

        //           width: w,
        //           color: Colors.red,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: showDownloadButton
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
                        onTap: () {},
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.black,
                            ),
                            Text('Get PDF')
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/excel_icon.svg',
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
