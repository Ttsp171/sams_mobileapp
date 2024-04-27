import 'package:flutter/material.dart';

import '../../services/api.dart';
import '../../utils/colors.dart';
import '../../widgets/alert_dailog.dart';
import '../../widgets/card.dart';
import '../../widgets/shimmer.dart';
import '../../widgets/textfield.dart';
import '../../widgets/toast.dart';

class WareHouseItemCode extends StatefulWidget {
  const WareHouseItemCode({super.key});

  @override
  State<WareHouseItemCode> createState() => _WareHouseItemCodeState();
}

class _WareHouseItemCodeState extends State<WareHouseItemCode> {
  List items = [], searchItems = [];
  int currentPage = 1;
  String itemCode = "";
  String itemName = "";
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getItems();
  }

  getItems() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res = await HttpServices()
        .postWIthTokenAndBody('/api/item-code-action', {'type': '1'});
    if (res["status"] == 200) {
      setState(() {
        items.addAll(res["data"]["data"]);
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

  deleteItem(itemId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/item-code-action', {'type': '5', 'item_id': itemId.toString()});
    print(res);
    if (res["status"] == 200) {
      setState(() {
        items.removeAt(index);
        _show = false;
      });
      showSuccessToast(res["data"]["message"]);
    } else {
      setState(() {
        _show = false;
      });
      showToast("Something went Wrong");
    }
  }

  addItem(context) async {
    if (itemCode == "") {
      showSuccessToast("Please Enter Item Code");
    } else if (itemName == "") {
      showSuccessToast("Please Enter Item Name");
    } else {
      setState(() {
        _show = true;
      });
      final res =
          await HttpServices().postWIthTokenAndBody('/api/item-code-action', {
        'type': '2',
        'item_code': itemCode.toString(),
        'item_description': itemName.toString()
      });
      if (res["status"] == 200) {
        setState(() {
          items = [];
          searchItems = [];
          itemName = "";
          itemCode = "";
        });
        Navigator.pop(context);
        getItems();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  editItem(itemId, context) async {
    if (itemCode == "") {
      showSuccessToast("Please Enter Item Code");
    } else if (itemName == "") {
      showSuccessToast("Please Enter Item Name");
    } else {
      setState(() {
        _show = true;
      });
      final res =
          await HttpServices().postWIthTokenAndBody('/api/item-code-action', {
        'type': '4',
        'item_code': itemCode.toString(),
        'item_description': itemName.toString(),
        'item_id': itemId.toString()
      });
      if (res["status"] == 200) {
        setState(() {
          items = [];
          searchItems = [];
          itemName = "";
          itemCode = "";
        });
        getItems();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  searchCity(keyword) async {}

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        isNextPage) {
      // getItems();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Items', style: TextStyle(color: Colors.white)),
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
                            //     searchItems = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchItems.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchItems.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name': searchItems[index]["name"] ?? ""
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
                            : searchItems.isEmpty &&
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
                                : items.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No items Found",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Item Code': items[index]
                                                        ["item_code"] ??
                                                    "",
                                                'Item Description': items[index]
                                                        ["item_description"] ??
                                                    "",
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  setState(() {
                                                    itemName = items[index][
                                                            "item_description"] ??
                                                        "";
                                                    itemCode = items[index]
                                                            ["item_code"] ??
                                                        "";
                                                  });
                                                  showTwoTextFieldAlert(
                                                      "Items Update Form",
                                                      "Item Code",
                                                      "Please enter Item Code",
                                                      itemCode,
                                                      (val) {
                                                        setState(() {
                                                          itemCode = val;
                                                        });
                                                      },
                                                      "Item Description",
                                                      "Please enter Item Description",
                                                      itemName,
                                                      (val) {
                                                        setState(() {
                                                          itemName = val;
                                                        });
                                                      },
                                                      () {
                                                        editItem(
                                                            items[index]["id"],
                                                            context);
                                                        Navigator.pop(context);
                                                      },
                                                      "Update",
                                                      () {
                                                        Navigator.pop(context);
                                                      },
                                                      context);
                                                },
                                                //   showTextFieldAlert(
                                                //       "Update City",
                                                //       "Enter City Name",
                                                //       itemName,
                                                //       (val) {
                                                //         itemName = val;
                                                //       },
                                                //       () {
                                                //         editItem(
                                                //             items[index]["id"],
                                                //             context);
                                                //         Navigator.pop(context);
                                                //       },
                                                //       "Update",
                                                //       () {
                                                //         Navigator.pop(context);
                                                //       },
                                                //       context);
                                                // },
                                                "onRightClick": () {
                                                  deleteItem(items[index]["id"],
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
          setState(() {
            itemName = "";
            itemCode = "";
          });
          showTwoTextFieldAlert(
              "Items Entry Form",
              "Item Code",
              "Please enter Item Code",
              itemCode,
              (val) {
                setState(() {
                  itemCode = val;
                });
              },
              "Item Description",
              "Please enter Item Description",
              itemName,
              (val) {
                setState(() {
                  itemName = val;
                });
              },
              () {
                addItem(context);
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
