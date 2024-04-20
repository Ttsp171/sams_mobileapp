import 'package:flutter/material.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/alert_dailog.dart';
import '../../../widgets/card.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';

class CompaniesDetail extends StatefulWidget {
  const CompaniesDetail({super.key});

  @override
  State<CompaniesDetail> createState() => _CompaniesDetailState();
}

class _CompaniesDetailState extends State<CompaniesDetail> {
  List companies = [], searchCompanies = [];
  String companyName = "";
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCompanies();
  }

  getCompanies() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res = await HttpServices()
        .postWIthTokenAndBody('/api/company', {'type': '1'});
    if (res["status"] == 200) {
      setState(() {
        companies.addAll(res["data"]["data"]);
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

  deleteCompany(companyId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/company', {'type': '5', 'company_id': companyId.toString()});
    print(res);
    if (res["status"] == 200) {
      setState(() {
        companies.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      setState(() {
        _show = false;
      });
      showToast("Something Went Wrong");
    }
  }

  addCompany(context) async {
    if (companyName == "") {
      showSuccessToast("Please Enter Company Name");
    } else {
      setState(() {
        _show = true;
      });
      final res = await HttpServices().postWIthTokenAndBody('/api/company',
          {'type': '2', 'company_name': companyName.toString()});
      if (res["status"] == 200) {
        setState(() {
          companies = [];
          searchCompanies = [];
          companyName = "";
        });
        getCompanies();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  editCompany(companyId, context) async {
    if (companyName == "") {
      showSuccessToast("Please Enter City Name");
    } else {
      setState(() {
        _show = true;
      });
      final res =
          await HttpServices().postWIthTokenAndBody('/api/company', {
        'type': '4',
        'company_name': companyName.toString(),
        'company_id': companyId.toString()
      });
      if (res["status"] == 200) {
        setState(() {
          companies = [];
          searchCompanies = [];
          companyName = "";
        });
        getCompanies();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  searchVacantProperty(keyword) async {
    // setState(() {
    //   searchCompanies = [];
    // });
    // for (var i in companies) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchCompanies.addAll(i);
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
  //       searchCompanies.addAll(res["data"]["data"]["data"]);
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
      // getcompanies();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('All Companies', style: TextStyle(color: Colors.white)),
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
                            //     searchCompanies = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchCompanies.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchCompanies.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name':
                                            searchCompanies[index]["name"] ?? ""
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
                            : searchCompanies.isEmpty &&
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
                                : companies.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No companies Found",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: companies.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Name': companies[index]
                                                        ["name"] ??
                                                    ""
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  setState(() {
                                                    companyName =
                                                        companies[index]
                                                                ["name"] ??
                                                            "";
                                                  });
                                                  showTextFieldAlert(
                                                      "Update Company",
                                                      "Enter COmpany Name",
                                                      companyName,
                                                      (val) {
                                                        companyName = val;
                                                      },
                                                      () {
                                                        editCompany(
                                                            companies[index]
                                                                ["id"],
                                                            context);
                                                        Navigator.pop(context);
                                                      },
                                                      "Update",
                                                      () {
                                                        Navigator.pop(context);
                                                      },
                                                      context);
                                                },
                                                "onRightClick": () {
                                                  deleteCompany(
                                                      companies[index]["id"],
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
          showTextFieldAlert(
              "Add Company",
              "Enter Company Name",
              companyName,
              (val) {
                companyName = val;
              },
              () {
                addCompany(context);
                Navigator.pop(context);
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
      ),
    );
  }
}
