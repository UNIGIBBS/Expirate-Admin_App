import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    Key? key,
    required this.currentDay,
    required this.currentMonth,
    required this.currentYear,
  }) : super(key: key);

  final int currentDay;
  final int currentMonth;
  final int currentYear;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$currentDay / $currentMonth / $currentYear",
              style: TextStyle(
                  fontSize: height*0.02
              ),
            ),
          ),
        ),
      ],
    );
  }
}