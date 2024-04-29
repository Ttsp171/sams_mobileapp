import 'package:flutter/material.dart';
import 'package:sams/screens/building_dashboard/room_arrangements/bed_arrangement.dart';
import 'package:sams/screens/building_dashboard/room_arrangements/room_arrangement.dart';

import '../../../utils/colors.dart';

class Arrangements extends StatefulWidget {
  const Arrangements({super.key});

  @override
  State<Arrangements> createState() => _ArrangementsState();
}

class _ArrangementsState extends State<Arrangements> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arrangements',
              style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: ColorTheme.primaryColor,
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'Room',
              ),
              Tab(
                text: 'Bed',
              )
            ],
            labelStyle: const TextStyle(fontSize: 13.0),
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: Colors.white,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: ColorTheme.primaryColor,
            unselectedLabelColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [RoomArrangement(), BedArrangement()],
        ),
      ),
    );
  }
}
