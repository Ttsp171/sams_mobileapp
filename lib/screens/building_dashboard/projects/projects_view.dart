import 'package:flutter/material.dart';

import '../../../services/api.dart';
import '../../../utils/colors.dart';
import '../../../widgets/alert_dailog.dart';
import '../../../widgets/card.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/textfield.dart';
import '../../../widgets/toast.dart';

class ProjectsDetail extends StatefulWidget {
  const ProjectsDetail({super.key});

  @override
  State<ProjectsDetail> createState() => _ProjectsDetailState();
}

class _ProjectsDetailState extends State<ProjectsDetail> {
  List projects = [], searchProjects = [];
  int currentPage = 1;
  String projectName = "";
  bool isLoading = false, isFirstTime = true, _show = true, isNextPage = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  getProjects() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    final res = await HttpServices()
        .postWIthTokenAndBody('/api/project', {'type': '1'});
    if (res["status"] == 200) {
      setState(() {
        projects.addAll(res["data"]["data"]);
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

  deleteProject(projectId, index) async {
    setState(() {
      _show = true;
    });
    final res = await HttpServices().postWIthTokenAndBody(
        '/api/project', {'type': '5', 'project_id': projectId.toString()});
    print(res);
    if (res["status"] == 200) {
      setState(() {
        projects.removeAt(index);
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

  addProject(context) async {
    if (projectName == "") {
      showSuccessToast("Please Enter Project Name");
    } else {
      setState(() {
        _show = true;
      });
      final res = await HttpServices().postWIthTokenAndBody('/api/project',
          {'type': '2', 'project_name': projectName.toString()});
      if (res["status"] == 200) {
        setState(() {
          projects = [];
          searchProjects = [];
          projectName = "";
        });
        getProjects();
        showSuccessToast(res["data"]["message"]);
      } else {
        setState(() {
          _show = false;
        });
        showToast("Something went Wrong");
      }
    }
  }

  editProject(projectId, context) async {
    if (projectName == "") {
      showSuccessToast("Please Enter Project Name");
    } else {
      setState(() {
        _show = true;
      });
      final res = await HttpServices().postWIthTokenAndBody('/api/project', {
        'type': '4',
        'project_name': projectName.toString(),
        'project_id': projectId.toString()
      });
      if (res["status"] == 200) {
        setState(() {
          projects = [];
          searchProjects = [];
          projectName = "";
        });
        getProjects();
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
    //   searchProjects = [];
    // });
    // for (var i in projects) {
    //   i.forEach((key, value) {
    //     if (value==keyword) {
    //       setState(() {
    //         _show = false;
    //       });
    //       searchProjects.addAll(i);
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
  //       searchProjects.addAll(res["data"]["data"]["data"]);
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
      // getProjects();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('All Projects', style: TextStyle(color: Colors.white)),
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
                            //     searchProjects = [];
                            //   });
                            // }
                          },
                        ),
                        const SizedBox(height: 20),
                        searchProjects.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: searchProjects.length,
                                  itemBuilder: (context, index) {
                                    return CardContainer(
                                      height: 260,
                                      datas: {
                                        'S. No': index + 1,
                                        'Name':
                                            searchProjects[index]["name"] ?? ""
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
                            : searchProjects.isEmpty &&
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
                                : projects.isEmpty
                                    ? const Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Projects Found",
                                              style: TextStyle(fontSize: 20),
                                            )),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount: projects.length,
                                          itemBuilder: (context, index) {
                                            return CardContainer(
                                              height: 260,
                                              datas: {
                                                'S. No': index + 1,
                                                'Name': projects[index]
                                                        ["name"] ??
                                                    ""
                                              },
                                              isBottomButton: true,
                                              bottomClickData: {
                                                "onLeftLabel": "Edit",
                                                "onRightLabel": "Delete",
                                                "onLeftClick": () {
                                                  setState(() {
                                                    projectName =
                                                        projects[index]
                                                                ["name"] ??
                                                            "";
                                                  });
                                                  showTextFieldAlert(
                                                      "Update Project",
                                                      "Enter Project Name",
                                                      projectName,
                                                      (val) {
                                                        projectName = val;
                                                      },
                                                      () {
                                                        editProject(
                                                            projects[index]
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
                                                  deleteProject(
                                                      projects[index]["id"],
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
            projectName = "";
          });
          showTextFieldAlert(
              "Add Project",
              "Enter Project Name",
              projectName,
              (val) {
                projectName = val;
              },
              () {
                addProject(context);
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
