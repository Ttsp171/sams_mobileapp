import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/card.dart';
import '../../../widgets/toast.dart';

class EmployeeReport extends StatefulWidget {
  final String customUrl;
  final List reportData;
  const EmployeeReport(
      {super.key, required this.customUrl, required this.reportData});

  @override
  State<EmployeeReport> createState() => _EmployeeReportState();
}

class _EmployeeReportState extends State<EmployeeReport> {
  bool showSave = true, downloading = false;

  getCSVPdfDownloadLink(type) async {
    setState(() {
      showSave = false;
    });
    final res = await HttpServices().getWithToken(
        '/api/get-employee-reports?type=$type${widget.customUrl == "" ? "" : widget.customUrl}',
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 239, 224),
      appBar: AppBar(
        title: const Text('Employee Reports',
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
      body: Column(
        children: [
          widget.reportData.isEmpty
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
                    itemCount: widget.reportData.length,
                    itemBuilder: (context, index) {
                      return CardContainer(
                        height: 200,
                        datas: {
                          'ID': index + 1,
                          'Facility': widget.reportData[index]["item"] ?? "",
                          'Building Name':
                              widget.reportData[index]["building_no"] ?? "",
                          'Room Number':
                              widget.reportData[index]["units"] ?? "",
                          'Bed Number': widget.reportData[index]["price"] ?? "",
                          'Name': widget.reportData[index]["name"] ?? "",
                          'Employee ID': widget.reportData[index]["item"] ?? "",
                          'Nationality':
                              widget.reportData[index]["nationality"] ?? "",
                          'Government Type':
                              widget.reportData[index]["gov_doc_type"] ?? "",
                          'Government ID':
                              widget.reportData[index]["gov_doc_id"] ?? "",
                          'Employee Type':
                              widget.reportData[index]["employee_type"] ?? "",
                          'Contact':
                              widget.reportData[index]["contact_no"] ?? "",
                          'Project': widget.reportData[index]["item"] ?? "",
                          'Company': widget.reportData[index]["units"] ?? "",
                          'From Date':
                              widget.reportData[index]["from_date"] ?? "",
                          'End Date':
                              widget.reportData[index]["end_date"] ?? "",
                          'Transfer':
                              widget.reportData[index]["transfer"] ?? "",
                          'Transfer Building': widget.reportData[index]
                                  ["transfe_building"] ??
                              "",
                          'Transfer Room No':
                              widget.reportData[index]["transfe_room"] ?? "",
                          'Transfer Bed No':
                              widget.reportData[index]["transfe_bed"] ?? "",
                        },
                        isBottomButton: false,
                        context: context,
                        bottomClickData: const {},
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.reportData.isEmpty
          ? const SizedBox()
          : MediaQuery(
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
                        getCSVPdfDownloadLink("3");
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
                        getCSVPdfDownloadLink("2");
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
            ),
    );
  }
}
