import 'package:flutter/cupertino.dart';

class UserLocation with ChangeNotifier{
  double? latitude;
  double? longitude;

  UserLocation({this.latitude, this.longitude});
}