import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    Key? key,
    required this.currentHour,
    required this.currentMin,
  }) : super(key: key);

  final int currentHour;
  final int currentMin;

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
              "$currentHour",
              style: TextStyle(
                  fontSize: height*0.02
              ),
            ),
          ),
        ),
        Text(":", style: TextStyle(fontSize: height*0.02, fontWeight: FontWeight.bold),),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentMin<=9 ? "0$currentMin" : "$currentMin",
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