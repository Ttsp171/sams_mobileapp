import 'package:flutter/material.dart';
import 'package:sams/controllers/navigation_controllers.dart';
import 'package:sams/screens/building_dashboard/city/cities_view.dart';
import 'package:sams/screens/building_dashboard/company/companies_view.dart';
import 'package:sams/screens/view_Pages/tickets/application_users/applicants.dart';
import 'package:sams/screens/view_Pages/tickets/fm_tickets/fmticket_view.dart';

import '../building_dashboard/projects/projects_view.dart';
import '../view_Pages/tickets/medical_tickets/medical_ticket.dart';

class EndDrawerCustom extends StatefulWidget {
  final String imageData;
  final BuildContext context;
  final String userName;
  const EndDrawerCustom(
      {super.key,
      required this.imageData,
      required this.userName,
      required this.context});

  @override
  State<EndDrawerCustom> createState() => _EndDrawerCustomState();
}

class _EndDrawerCustomState extends State<EndDrawerCustom> {
  List drawerItems = [];

  @override
  void initState() {
    super.initState();
    drawerItems.addAll([
      {
        "itemName": "Home",
        "isExpand": false,
        "icon": Icons.home,
        "onTap": () {},
        "expandItems": []
      },
      {
        "itemName": "Building Dashboard",
        "isExpand": true,
        "icon": Icons.build_sharp,
        "onTap": () {},
        "expandItems": [
          {
            "itemName": "City",
            "icon": Icons.location_city,
            "onTap": () {
              navigateWithRoute(context, const CitiesDetail());
            },
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Building Log",
            "icon": Icons.build_circle,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Company",
            "icon": Icons.compare_sharp,
            "onTap": () {
              navigateWithRoute(context, const CompaniesDetail());
            },
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Projects",
            "icon": Icons.personal_injury,
            "onTap": () {
              navigateWithRoute(context, const ProjectsDetail());
            },
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Room Arrangement",
            "icon": Icons.room_outlined,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
        ]
      },
      {
        "itemName": "Sample 2",
        "isExpand": true,
        "icon": Icons.home,
        "expandItems": [
          {
            "itemName": "Sub Samp1",
            "icon": Icons.abc,
            "isSubExpand": true,
            "expandItems": [
              {
                "itemName": "sunMenu2",
                "icon": Icons.area_chart,
                "isExpand": false,
                "expandItems": []
              },
              {
                "itemName": "sunMenu2",
                "icon": Icons.area_chart,
                "isExpand": false,
                "expandItems": []
              },
            ]
          }
        ]
      },
      {
        "itemName": "Villa",
        "isExpand": true,
        "icon": Icons.villa,
        "onTap": () {},
        "expandItems": [
          {
            "itemName": "nsdfksdfn",
            "icon": Icons.villa_outlined,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          }
        ]
      },
      {
        "itemName": "Camp",
        "isExpand": false,
        "onTap": () {},
        "icon": Icons.campaign,
        "expandItems": []
      },
      {
        "itemName": "Tickets",
        "isExpand": true,
        "onTap": () {},
        "icon": Icons.airplane_ticket,
        "expandItems": [
          {
            "itemName": "FM Tickets",
            "icon": Icons.airplane_ticket,
            "onTap": () {
              navigateWithRoute(widget.context, const FMTicketView());
            },
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Medical Tickets",
            "icon": Icons.airplane_ticket,
            "onTap": () {
              navigateWithRoute(widget.context, const MedicalTicketView());
            },
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Application Users",
            "icon": Icons.airplane_ticket,
            "onTap": () {
              navigateWithRoute(widget.context, const ApplicantsView());
            },
            "isSubExpand": false,
            "expandItems": []
          },
        ]
      },
      {
        "itemName": "Warehouse",
        "isExpand": true,
        "icon": Icons.warehouse,
        "onTap": () {},
        "expandItems": [
          {
            "itemName": "Request Inventory",
            "icon": Icons.inventory,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Inventory",
            "icon": Icons.inventory,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Inventory Out List",
            "icon": Icons.inventory,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "ITEM Code",
            "icon": Icons.inventory,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Warehouse City",
            "icon": Icons.warehouse,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
        ]
      },
      {
        "itemName": "Reports",
        "isExpand": true,
        "icon": Icons.report,
        "onTap": () {},
        "expandItems": [
          {
            "itemName": "Employee Reports",
            "icon": Icons.emoji_people_outlined,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Warehouse Reports",
            "icon": Icons.warehouse,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Building Reports",
            "icon": Icons.build_circle,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          },
          {
            "itemName": "Man Days Summary",
            "icon": Icons.inventory,
            "onTap": () {},
            "isSubExpand": false,
            "expandItems": []
          }
        ]
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.05),
        child: Column(
          children: [
            // SizedBox(
            //   height: h * 0.1,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       IconButton(
            //         icon: CircleAvatar(
            //           backgroundColor: const Color(0xFF005689),
            //           radius: 20,
            //           child: Image.network(widget.imageData),
            //         ),
            //         iconSize: 35,
            //         onPressed: () {},
            //       ),
            //       Text(widget.userName),
            //       const Icon(
            //         Icons.verified_rounded,
            //         color: Colors.green,
            //       )
            //     ],
            //   ),
            // ),

            Expanded(
              child: ListView.builder(
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  return _buildItem(drawerItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    if (item["isExpand"]) {
      return ExpansionTile(
        title: Text(item["itemName"]),
        leading: Icon(item["icon"]),
        children: [
          for (var subItem in item["expandItems"]) _buildSubItem(subItem),
        ],
      );
    } else {
      return ListTile(
        title: Text(item["itemName"]),
        leading: Icon(item["icon"]),
        onTap: item["onTap"],
      );
    }
  }

  Widget _buildSubItem(Map<String, dynamic> subItem) {
    if (subItem["isSubExpand"]) {
      return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: ExpansionTile(
          title: Text(subItem["itemName"]),
          leading: Icon(subItem["icon"]),
          children: [
            for (var innerSubItem in subItem["expandItems"])
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(innerSubItem["itemName"]),
                  leading: Icon(innerSubItem["icon"]),
                  onTap: innerSubItem["onTap"],
                ),
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ListTile(
          title: Text(subItem["itemName"]),
          leading: Icon(subItem["icon"]),
          onTap: subItem["onTap"],
        ),
      );
    }
  }
  //   return Drawer(
  //     child: Column(children: [
  //       SizedBox(
  //         height: h * 0.1,
  //         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //           IconButton(
  //             icon: CircleAvatar(
  //                 backgroundColor: const Color(0xFF005689),
  //                 radius: 20,
  //                 child: Image.network(widget.imageData)),
  //             iconSize: 35,
  //             onPressed: () {},
  //           ),
  //           Text(widget.userName),
  //           const Icon(
  //             Icons.verified_rounded,
  //             color: Colors.green,
  //           )
  //         ]),
  //       ),
  //       SizedBox(
  //         height: h*0.89,
  //         child: ListView.builder(
  //           itemCount: drawerItems.length,
  //           itemBuilder: (context, index) {
  //             return drawerItems[index]["isExpand"]
  //                 ? ExpansionTile(
  //                     title: Text(drawerItems[index]["itemName"]),
  //                     children: [
  //                         ListView.builder(
  //                             itemCount:
  //                                 drawerItems[index]["expandItems"].length,
  //                             itemBuilder: (context, subindex) {
  //                               return drawerItems[index]["expandItems"]
  //                                       [subindex]["isSubExpand"]
  //                                   ? ExpansionTile(
  //                                       title: Text(drawerItems[index]
  //                                               ["expandItems"][subindex]
  //                                           ["itemName"]),
  //                                       children: [
  //                                         ListView.builder(
  //                                             itemCount: drawerItems[index]
  //                                                         ["expandItems"]
  //                                                     [subindex]["expandItems"]
  //                                                 .length,
  //                                             itemBuilder:
  //                                                 (context, lastIndex) {
  //                                               return ListTile(
  //                                                 title: Text(drawerItems[index]
  //                                                                 [
  //                                                                 "expandItems"]
  //                                                             [
  //                                                             subindex]
  //                                                         ["expandItems"]
  //                                                     [lastIndex]["itemName"]),
  //                                               );
  //                                             })
  //                                       ],
  //                                     )
  //                                   : ListTile(
  //                                       title: Text(drawerItems[index]
  //                                               ["expandItems"][subindex]
  //                                           ["itemName"]),
  //                                     );
  //                             }),
  //                       ])
  //                 : ListTile(
  //                     title: Text(drawerItems[index]["itemName"]),
  //                   );
  //           },
  //         ),
  //       )
  //     ]),
  //   );
  // }
}
