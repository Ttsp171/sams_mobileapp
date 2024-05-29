import 'package:flutter/material.dart';
import 'package:sams/screens/user_directory/add_user.dart';

import '../../controllers/datetime_controller.dart';
import '../../controllers/navigation_controllers.dart';
import '../../services/api.dart';
import '../../utils/colors.dart';
import '../../widgets/card.dart';
import '../../widgets/shimmer.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class UserDirectory extends StatefulWidget {
  const UserDirectory({super.key});

  @override
  State<UserDirectory> createState() => _UserDirectoryState();
}

class _UserDirectoryState extends State<UserDirectory> {
  List users = [], searchUsers = [];
  int currentPage = 1;
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getusersData();
  }

  getusersData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res =
        await HttpServices().getWithToken('/api/user-directory-list', context);
    if (res["status"] == 200) {
      setState(() {
        users.addAll(res["data"]["data"]);
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
    //   searchUsers = [];
    // });
    // for (var i in users) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchUsers.addAll(i);
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
  //       searchUsers.addAll(res["data"]["data"]["data"]);
  //     });
  //   }
  // } else {
  //   setState(() {
  //     _show = false;
  //   });
  //   showToast(res["data"]["message"]);
  // }

  deleteTicket(userId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices()
        .getWithToken('/api/delete-user?user_id=${userId.toString()}', context);
    if (res["status"] == 200) {
      setState(() {
        users.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      showToast("Something went wrong");
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      // getusersData();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('User Directory', style: TextStyle(color: Colors.white)),
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
                            //     searchUsers = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchUsers.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchUsers.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name': searchUsers[index]
                                                ["employee_name"] ??
                                            "",
                                        'Email':
                                            searchUsers[index]["subject"] ?? "",
                                      },
                                      isBottomButton: true,
                                      bottomClickData: {
                                        "onLeftLabel": "Edit",
                                        "onRightLabel": "Delete",
                                        "onLeftClick": () {},
                                        "onRightClick": () {
                                          deleteTicket(
                                              searchUsers[index]
                                                  ["employee_name"]["id"],
                                              index);
                                        }
                                      },
                                      context: context,
                                    );
                                  },
                                ),
                              )
                            : searchUsers.isEmpty &&
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
                                : users.isEmpty
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
                                          itemCount: users.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Name':
                                                    users[index]["name"] ?? "",
                                                'Email':
                                                    users[index]["email"] ?? "",
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {},
                                                "onRightClick": () {
                                                  deleteTicket(
                                                      users[index]["id"],
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
          navigateWithRoute(context, const AddUserDirectory());
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
