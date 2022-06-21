import 'package:comp_part1_2/services/map_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  Location({
    Key? key,
    required this.city,
    required this.village,
    required this.lat,
    required this.lng,
    required this.username,
  }) : super(key: key);

  String city;
  String village;
  String username;
  var lat;
  var lng;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$city, $village",
                    style: TextStyle(
                        fontSize: height*0.015,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.1
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8,8,8),
                    child: Container(
                      height: 1,
                      width: width/2,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "$username",
                    style: TextStyle(
                      fontSize: height*0.02,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width/5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  MapUtils.openMap(lat, lng);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent,
                  ),
                  child: Icon(
                    CupertinoIcons.location,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
