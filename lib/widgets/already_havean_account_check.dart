import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function() press;

  const AlreadyHaveAnAccountCheck({
    Key? key, this.login = true, required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
          Text(login? "Don't have an Account ?": "Already have an Account ?",
            style: TextStyle(
                color: Colors.blue
            ),),
          GestureDetector(
            onTap: press,
            child: Text(login? "Sign Up": "Sign In",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}