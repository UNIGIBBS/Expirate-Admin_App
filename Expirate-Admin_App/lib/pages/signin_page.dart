import 'package:comp_part1_2/pages/forgot_password_page.dart';
import 'package:comp_part1_2/pages/home_page.dart';
import 'package:comp_part1_2/services/authentication_services.dart';
import 'package:comp_part1_2/widgets/SignInSignUpButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var auth = AuthenticationService(FirebaseAuth.instance);

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  String? text = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          color: Colors.white,
          width: double.infinity,
          height: size.height,
          child: ListView(
              children: <Widget> [
                SingleChildScrollView(
                  child: Column(
                    children:<Widget> [
                      SizedBox(height: height*0.1,),
                      //Text("LOGIN", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 20),
                        child: TextField(
                          onChanged: (value){},
                          cursorColor: Colors.redAccent,
                          keyboardType: TextInputType.text,
                          controller: emailController ,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
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
                        padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 20),
                        child: TextField(
                          onChanged: (value){},

                          obscureText: _obscureText,
                          cursorColor: Colors.redAccent,
                          keyboardType: TextInputType.text,
                          controller: passwordController ,
                          decoration: InputDecoration(
                              prefixIconColor: Colors.redAccent,
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility,), onPressed: _toggle,),
                              labelText: "Password ",
                              hintText: "Password ",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.02,),
                      SingInSingUpButton(context: context,
                        isLogin: true,
                        boyut: 0.8,
                        onTap: (){
                          auth.signIn(email: emailController.text, password: passwordController.text);
                        },
                      ),
                      SizedBox(height: size.height*0.05,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                          },
                          child: Text("Forgot Password?"))


                    ],

                  ),
                ),]
          )),
    );
  }
}
