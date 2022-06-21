import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SingInSingUpButton extends StatelessWidget {
  BuildContext context;
  bool isLogin;
  Function onTap;
  double boyut;

  SingInSingUpButton({
    required this.boyut,
    required this.context,
    required this.isLogin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      elevation: 20,
      child: Container(
        width: MediaQuery.of(context).size.width * boyut,
        height: 50,
        margin: const EdgeInsets.fromLTRB(5, 3, 0, 3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: ElevatedButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
            onTap();
          },
          child: Text(
            isLogin ? 'LOG IN ' : 'SIGN UP',
            style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14
            ),
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
    );
  }
}
