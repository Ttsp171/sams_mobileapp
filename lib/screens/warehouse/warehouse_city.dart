import 'package:flutter/material.dart';
import 'package:sams/widgets/alert_dailog.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/card.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';

class WareHouseCitiesDetail extends StatefulWidget {
  const WareHouseCitiesDetail({super.key});

  @override
  State<WareHouseCitiesDetail> createState() => _WareHouseCitiesDetailState();
}

class _WareHouseCitiesDetailState extends State<WareHouseCitiesDetail> {
  List cities = [], searchCities = [];
  int currentPage = 1;
  String cityName = "";
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCities();
  }

  getCities() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res = await HttpServices()
        .postWIthTokenAndBody('/api/warehouse-city-action', {'type': '1'});
    if (res["status"] == 200) {
      setState(() {
        cities.addAll(res["data"]["data"]);
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

  deleteCity(cityId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/warehouse-city-action', {'type': '5', 'warehouse_city_id': cityId.toString()});
    print(res);
    if (res["status"] == 200) {
      setState(() {
        cities.removeAt(index);
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

  addCity(context) async {
    if (cityName == "") {
      showSuccessToast("Please Enter Location Name");
    } else {
      setState(() {
        _show = true;
      });
      final res = await HttpServices().postWIthTokenAndBody(
          '/api/warehouse-city-action',
          {'type': '2', 'warehouse_city_name': cityName.toString()});
      if (res["status"] == 200) {
        setState(() {
          cities = [];
          searchCities = [];
          cityName = "";
        });
        getCities();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  editCity(cityId, context) async {
    if (cityName == "") {
      showSuccessToast("Please Enter Location Name");
    } else {
      setState(() {
        _show = true;
      });
      final res = await HttpServices().postWIthTokenAndBody(
          '/api/warehouse-city-action', {
        'type': '4',
        'warehouse_city_name': cityName.toString(),
        'warehouse_city_id': cityId.toString()
      });
      if (res["status"] == 200) {
        setState(() {
          cities = [];
          searchCities = [];
          cityName = "";
        });
        getCities();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  searchVacantProperty(keyword) async {}

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        isNextPage) {
      // getcities();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('All WareHouse', style: TextStyle(color: Colors.white)),
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
                            //     searchCities = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchCities.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchCities.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name':
                                            searchCities[index]["name"] ?? ""
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
                            : searchCities.isEmpty &&
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
                                : cities.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Cities Found",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: cities.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Name':
                                                    cities[index]["name"] ?? ""
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  setState(() {
                                                    cityName = cities[index]
                                                            ["name"] ??
                                                        "";
                                                  });
                                                  showTextFieldAlert(
                                                      "Update Location",
                                                      "Enter Location Name",
                                                      cityName,
                                                      (val) {
                                                        cityName = val;
                                                      },
                                                      () {
                                                        editCity(
                                                            cities[index]["id"],
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
                                                  deleteCity(
                                                      cities[index]["id"],
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
            cityName = "";
          });
          showTextFieldAlert(
              "Add Location",
              "Please Enter Location Name",
              cityName,
              (val) {
                cityName = val;
              },
              () {
                addCity(context);
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
