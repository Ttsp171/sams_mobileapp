import 'package:flutter/material.dart';
import 'package:sams/controllers/imageview_controller.dart';
import 'package:sams/controllers/navigation_controllers.dart';

import 'buttons.dart';

Widget workOrderCard({
  required BuildContext context,
  required String workOrderName,
  required String workOrderId,
  required String date,
  required String time,
  required String status,
  required String type,
  required String priority,
  required VoidCallback onViewAllPressed,
  required VoidCallback documentsPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      border: Border.all(
        color: Colors.grey.shade300,
        width: 2.0,
      ),
    ),
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              child: Text(
                workOrderName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              date,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            time,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'WorkOrder ID',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              workOrderId,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              status,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Type',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Priority',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              priority,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onViewAllPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF005689),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Details'),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: documentsPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF005689),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Documents'),
            ),
          ],
        ),
      ],
    ),
  );
}

class CardContainer extends StatefulWidget {
  final Map datas;
  final double height;
  final bool isBottomButton;
  final Map bottomClickData;
  const CardContainer(
      {super.key,
      required this.datas,
      required this.isBottomButton,
      required this.height,
      required this.bottomClickData});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  List keys = [], values = [];
  @override
  void initState() {
    super.initState();
    setDataCard();
  }

  setDataCard() {
    widget.datas.forEach((key, value) {
      setState(() {
        keys.add(key);
        values.add(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: keys.map((e) {
                    var index = keys.indexOf(e);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                keys[index],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Text(
                              "         :      ",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              width: 150,
                              child: keys[index] == "Attachment" &&
                                      values[index] != ""
                                  ? customFlatButtomwithSize('View', () {
                                      navigateWithRoute(
                                          context,
                                          ImageViewCustom(
                                              imageUrl: values[index]));
                                    }, h * 0.03, w * 0.30, Colors.white,
                                      Colors.white, Colors.blue.shade300, false)
                                  : Text(
                                      values[index] == "" ||
                                              values[index] == null ||
                                              values[index] == "null"
                                          ? "   -"
                                          : values[index].toString(),
                                      style: values[index] == "" ||
                                              values[index] == null ||
                                              values[index] == "null"
                                          ? const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)
                                          : const TextStyle(fontSize: 14),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList()),
              const SizedBox(
                height: 15,
              ),
              if (widget.isBottomButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customFlatButtomwithSize(
                        widget.bottomClickData["onLeftLabel"],
                        widget.bottomClickData["onLeftClick"],
                        h * 0.06,
                        w * 0.30,
                        Colors.white,
                        Colors.white,
                        Colors.orange,
                        false),
                    customFlatButtomwithSize(
                        widget.bottomClickData["onRightLabel"],
                        widget.bottomClickData["onRightClick"],
                        h * 0.06,
                        w * 0.30,
                        Colors.orange,
                        Colors.orange,
                        Colors.white,
                        false),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
