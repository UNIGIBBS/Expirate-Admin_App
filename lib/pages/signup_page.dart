import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp_part1_2/pages/create_profile_page.dart';
import 'package:comp_part1_2/pages/page.dart';
import 'package:comp_part1_2/providers/sign_up_provider.dart';
import 'package:comp_part1_2/widgets/SignInSignUpButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/authentication_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var auth = AuthenticationService(FirebaseAuth.instance);

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? text = "";
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Container(
            color: Colors.white,
            width: width,
            height: size.height,
            child: ListView(
                children: <Widget> [
                  SingleChildScrollView(
                    child: Column(
                      children:<Widget> [
                        SizedBox(height: height*0.03,),
                        // Text("SIGNUP", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 8),
                          child: TextField(


                            cursorColor: Colors.redAccent,
                            keyboardType: TextInputType.text,
                            controller: userNameController ,
                            onChanged: (value){
                              Provider.of<SLpage>(context, listen: false).makeFalse();
                              print("user changed");
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "User Name",
                                hintText: "User Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.redAccent)
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 8),
                          child: TextField(
                            onChanged: (value){

                            },
                            cursorColor: Colors.redAccent,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController ,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: "Email",
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.redAccent)
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 8),
                          child: TextField(

                            obscureText: _obscureText,
                            onChanged: (value){},
                            cursorColor: Colors.redAccent,
                            keyboardType: TextInputType.text,
                            controller: passwordController ,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility), onPressed: _toggle,),
                                labelText: "Password",
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.redAccent)
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 20),
                          child: TextField(
                            onChanged: (value){},
                            cursorColor: Colors.redAccent,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.text,
                            controller: passwordController2 ,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility), onPressed: _toggle,),
                                labelText: "Password Again",
                                hintText: "Password Again",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.redAccent,style: BorderStyle.solid)
                                )
                            ),
                          ),
                        ),
                        SingInSingUpButton(
                          context: context,
                          isLogin: false,
                          boyut: 0.8,
                          onTap: (){
                            Provider.of<SignUpProvider>(context, listen: false).updateUserName(userNameController.text);
                            print("Igot pressed");
                            auth.signUp(email: emailController.text, password: passwordController.text).then((value)async{
                              await FirebaseFirestore.instance.collection("Markets").doc("${FirebaseAuth.instance.currentUser?.uid}").set({
                                "username": userNameController.text,
                                "email": emailController.text,
                              });
                            });
                          },
                        ),
                        SizedBox(height: size.height*0.0001,),


                      ],

                    ),
                  ),]
            )),
      ),
    );
  }
}
signUp(email, password) async{
  var url = "https://10.0.2.2:5000/signup";
  final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password
      })
  );

  print(response.body);
  // if(response.statusCode == 201){
  //
  // }
}