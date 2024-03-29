import 'package:flutter/material.dart';

class DashboardWidgetContainer extends StatelessWidget {
  final String widgetName;
  final IconData icon;
  final Color color1;
  final Color color2;
  final Color color3;
  final String count;
  final VoidCallback onClick;

  const DashboardWidgetContainer(
      {super.key,
      required this.widgetName,
      required this.icon,
      required this.color1,
      required this.color2,
      required this.onClick,
      required this.count,
      required this.color3});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.3,
      width: w * 0.90,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.5, 1.0],
            colors: [
              color1,
              color2,
              color3,
            ],
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: h * 0.08, left: 20),
            child: Row(
              children: [
                Text(
                  widgetName,
                  style: const TextStyle(
                      fontFamily: "Serif", fontSize: 30, color: Colors.white),
                ),
                Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 40),
            child: Text(
              count,
              style: const TextStyle(
                  fontFamily: "Serif", fontSize: 20, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
