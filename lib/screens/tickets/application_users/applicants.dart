import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/utils/colors.dart';
import 'package:sams/widgets/card.dart';

import '../../../services/api.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';
import '../../dashboard/dashboard_page.dart';

class ApplicantsView extends StatefulWidget {
  const ApplicantsView({super.key});

  @override
  State<ApplicantsView> createState() => _ApplicantsViewState();
}

class _ApplicantsViewState extends State<ApplicantsView> {
  List applicants = [], searchApplicants = [];
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getApplicants();
  }

  getApplicants() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res = await HttpServices().getWithToken(
        '/api/application-user-list?page=$currentPage&per_page=10', context);
    if (res["status"] == 200) {
      setState(() {
        applicants.addAll(res["data"]["original"]["data"]["data"]);
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
    //   searchApplicants = [];
    // });
    // for (var i in applicants) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchApplicants.addAll(i);
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
  //       searchApplicants.addAll(res["data"]["data"]["data"]);
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
      getApplicants();
      return true;
    }
    return false;
  }

  deleteApplicant(applicantId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/action-of-application-user',
        {'app_user_id': applicantId.toString(), 'type': '3'});
    if (res["status"] == 200) {
      setState(() {
        applicants.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["original"]["message"]);
    } else {
      showToast("Something went wrong");
    }
  }

  updateApplicant(applicantId, type, context) async {
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/action-of-application-user',
        {'app_user_id': applicantId.toString(), 'type': type.toString()});
    if (res["status"] == 200) {
      showSuccessToast(res["data"]["original"]["message"]);
      navigateWithoutRoute(context, const DashBoardMain());
      navigateWithRoute(context, const ApplicantsView());
    } else {
      showToast("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application User List',
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
                            //     searchApplicants = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchApplicants.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchApplicants.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name': searchApplicants[index]
                                                ["user_name"] ??
                                            "",
                                        'Email': searchApplicants[index]
                                                ["email"] ??
                                            "",
                                        'Phone': searchApplicants[index]
                                                ["contact_number"] ??
                                            ""
                                      },
                                      isBottomButton: true,
                                      bottomClickData: {
                                        "onEditClick": () {},
                                        "onDeleteClick": () {
                                          deleteApplicant(
                                              searchApplicants[index]["id"],
                                              index);
                                        }
                                      }, context: context,
                                    );
                                  },
                                ),
                              )
                            : searchApplicants.isEmpty &&
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
                                : applicants.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Applicants Found",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: applicants.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Name': applicants[index]
                                                        ["user_name"] ??
                                                    "",
                                                'Email': applicants[index]
                                                        ["email"] ??
                                                    "",
                                                'Phone': applicants[index]
                                                        ["contact_number"] ??
                                                    ""
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": applicants[index]
                                                            ["user_block"] ==
                                                        0
                                                    ? "Block"
                                                    : "UnBlock",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  updateApplicant(
                                                      applicants[index]["id"],
                                                      applicants[index][
                                                                  "user_block"] ==
                                                              1
                                                          ? "0"
                                                          : "1",
                                                      context);
                                                },
                                                "onRightClick": () {
                                                  deleteApplicant(
                                                      applicants[index]["id"],
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
    );
  }
}
