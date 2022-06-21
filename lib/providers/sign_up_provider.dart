import 'package:flutter/cupertino.dart';

class SignUpProvider with ChangeNotifier{
  String username = "";

  SignUpProvider({required this.username});

  updateUserName(String newUserName){
    username = newUserName;
    notifyListeners();
  }

  String getUserName(){
    return username;
  }

}