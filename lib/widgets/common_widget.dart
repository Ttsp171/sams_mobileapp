import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sams/utils/colors.dart';

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
                  fontFamily: "Serif", fontSize: 30, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class DashBoardIconCustom extends StatelessWidget {
  final double customWidth;
  final double customHeight;
  final Color containerColor;
  final Widget child;
  const DashBoardIconCustom(
      {super.key,
      required this.customWidth,
      required this.customHeight,
      required this.containerColor,
      required this.child});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * customHeight,
      width: w * customWidth,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
        ],
      ),
    );
  }
}

class ChildWidgetWithSub extends StatelessWidget {
  final String subHeading;
  final String child1Label;
  final String child2Label;
  final String child1Count;
  final String child2Count;
  final Color label1Color;
  final Color label2Color;
  const ChildWidgetWithSub(
      {super.key,
      required this.subHeading,
      required this.child1Label,
      required this.child2Label,
      required this.child1Count,
      required this.child2Count,
      required this.label1Color,
      required this.label2Color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subHeading,
                style: const TextStyle(fontFamily: "Serif", fontSize: 26),
              )),
          Row(
            children: [
              DashBoardIconCustom(
                  customWidth: 0.4,
                  customHeight: 0.1,
                  containerColor: label1Color,
                  child: Column(
                    children: [
                      Text(
                        child1Label,
                        style:
                            const TextStyle(fontFamily: "Poppin", fontSize: 22),
                      ),
                      Text(
                        child1Count,
                        style:
                            const TextStyle(fontFamily: "Poppin", fontSize: 22),
                      ),
                    ],
                  )),
              DashBoardIconCustom(
                  customWidth: 0.4,
                  customHeight: 0.1,
                  containerColor: label2Color,
                  child: Column(
                    children: [
                      Text(
                        child2Label,
                        style:
                            const TextStyle(fontFamily: "Poppin", fontSize: 22),
                      ),
                      Text(
                        child2Count,
                        style:
                            const TextStyle(fontFamily: "Poppin", fontSize: 22),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

Widget dashboardHeadLabelCount(labelText, count) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text(
          labelText,
          style: const TextStyle(fontFamily: "Poppin", fontSize: 22),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text(
          count,
          style: const TextStyle(fontFamily: "Poppin", fontSize: 22),
        ),
      ),
    ],
  );
}

class DateTimeField extends StatefulWidget {
  final bool isRequired;
  final String labelText;
  final String hintText;
  final ValueChanged onChanged;
  final String? errorText;

  const DateTimeField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    this.errorText,
    required this.onChanged,
  });

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
        print(_dateController.text);
        widget.onChanged(DateFormat('yyyy-MM-dd').format(_selectedDate));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.85,
      height: height * 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                widget.labelText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  " *",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                  ),
                ),
              if (widget.errorText != null)
                Text(
                  "   ${widget.errorText}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.shade600,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                hintText: widget.hintText,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      ),
    );
  }
}

class DashBoardTopContainer extends StatelessWidget {
  final String iconUrl;
  final String count;
  final String labelText;
  final Color countColor;
  const DashBoardTopContainer(
      {super.key,
      required this.iconUrl,
      required this.count,
      required this.labelText,
      required this.countColor});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.44,
      height: h * 0.16,
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(iconUrl),
                Text(
                  labelText,
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 20,
                      color: ColorTheme.dashboardIconColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Text(count,
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 52,
                    color: countColor,
                    fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}

class DashBoardTop extends StatelessWidget {
  final String userName;
  final String imageData;
  const DashBoardTop(
      {super.key, required this.userName, required this.imageData});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h * 0.15,
      decoration: const BoxDecoration(
        color: Color(0xffFFA500),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Row(
        children: [
          imageData != ""
              ? Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(20),
                  child: CircleAvatar(
                      backgroundColor: const Color(0xFF005689),
                      radius: 30,
                      child: Image.network(imageData)),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(20),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: SvgPicture.asset("assets/svg/profile_icon.svg")),
                ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $userName!",
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter"),
                ),
                const Text(
                  "Have a nice day",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashBoardMiddleSlide extends StatelessWidget {
  final String count;
  final Color countColor;
  final String labelText;
  const DashBoardMiddleSlide(
      {super.key,
      required this.count,
      required this.countColor,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.93,
      height: h * 0.06,
      decoration: const BoxDecoration(
        color: Color(0xffFFF7EC),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          SizedBox(
            height: h * 0.06,
            width: w * 0.50,
            child: Center(
              child: Text(
                labelText,
                style: TextStyle(
                    fontSize: 22,
                    color: ColorTheme.dashboardMiddleTextColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter"),
              ),
            ),
          ),
          Container(
            height: h * 0.06,
            width: w * 0.42,
            decoration: const BoxDecoration(
              color: Color(0xffFFECCC),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15)),
            ),
            child: Center(
              child: Text(
                count,
                style: TextStyle(
                    fontSize: 42,
                    color: countColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DashBoardCenter extends StatelessWidget {
  final String labelText;
  final String leftLabelText;
  final String rightLabelText;
  final String leftCount;
  final String rightCount;
  final Color countColor;
  const DashBoardCenter(
      {super.key,
      required this.labelText,
      required this.leftLabelText,
      required this.rightLabelText,
      required this.leftCount,
      required this.rightCount,
      required this.countColor});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w * 0.93,
      height: h * 0.17,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashBoardMini(
            labelText: labelText,
          ),
          Container(
            width: w * 0.93,
            height: h * 0.13,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(w * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset("assets/svg/room_icon.svg"),
                          Text(
                            leftLabelText,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 20,
                                color: ColorTheme.dashboardIconColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(leftCount,
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 42,
                              color: countColor,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                SizedBox(
                    height: h * 0.11,
                    child: const VerticalDivider(
                      color: Color(0xffD9D9D9),
                    )),
                Padding(
                  padding: EdgeInsets.all(w * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset("assets/svg/bed_icon.svg"),
                          ),
                          Text(
                            rightLabelText,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 20,
                                color: ColorTheme.dashboardIconColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(rightCount,
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 42,
                              color: countColor,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DashBoardBottom extends StatelessWidget {
  final VoidCallback onLeftClick;
  final VoidCallback onRightClick;

  const DashBoardBottom(
      {super.key, required this.onLeftClick, required this.onRightClick});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h * 0.09,
      decoration: const BoxDecoration(
        color: Color(0xffFFA500),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: onLeftClick,
            child: SizedBox(
              width: w * 0.35,
              height: h * 0.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SvgPicture.asset(
                      "assets/svg/profile_icon.svg",
                      color: Colors.white,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: "Inter"),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: h * 0.06,
            width: w * 0.01,
            color: Colors.white,
          ),
          InkWell(
            onTap: onRightClick,
            child: SizedBox(
              width: w * 0.35,
              height: h * 0.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SvgPicture.asset(
                      "assets/svg/menu_icon.svg",
                      color: Colors.white,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const Text(
                    'Menu',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: "Inter"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashBoardMini extends StatelessWidget {
  final String labelText;
  const DashBoardMini({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.35,
      height: h * 0.04,
      decoration: const BoxDecoration(
        color: Color(0xffFFF7EC),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Center(
        child: Text(
          labelText,
          style: const TextStyle(
              fontSize: 22,
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              fontFamily: "Inter"),
        ),
      ),
    );
  }
}
