
import 'package:comp_part1_2/pages/signin_page.dart';
import 'package:comp_part1_2/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';

Widget signupPage = SignUpPage();
Widget signinPage = SignInPage();

class SLpage with ChangeNotifier{

  bool _isLogin = false;

  bool get isLogin => _isLogin;
  Widget get Login{
    return _isLogin? signinPage : signupPage;
  }
  void toggleLogin(){
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void makeFalse(){
    _isLogin = false;
    notifyListeners();
  }
  void makeTrue(){
    _isLogin = true;
    notifyListeners();
  }


}