import 'package:comp_part1_2/widgets/SignInSignUpButton.dart';
import 'package:comp_part1_2/widgets/decoration.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);


  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
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

                      SizedBox(height: height * 0.3,),
                      Text("Reset Password", style: style_arguments(Colors.black, FontWeight.bold, height*0.04, 'Open Sans')),
                      SizedBox(height: size.height*0.03,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(width*0.05, 8, width*0.05, 8),
                        child: TextField(
                          onChanged: (value){},
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
                        child: ElevatedButton(
                          onPressed: (){
                          },
                          child: Text(
                              "Send Mail",
                              style: style_arguments(Colors.black87, FontWeight.bold, height*0.02, 'Open Sans')
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states){
                                if(states.contains(MaterialState.pressed)){
                                  return Colors.black26;
                                }
                                return Colors.white;
                              }),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.0001,),


                    ],

                  ),
                ),]
          )),
    );
  }
}
