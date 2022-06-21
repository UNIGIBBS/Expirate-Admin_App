
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationService with ChangeNotifier{

  AuthenticationService(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

  Stream<User?> get authService => firebaseAuth.authStateChanges();

  Future<String> signIn({String? email, String? password}) async{
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email!, password: password!);
      print("Signed in");
      return "Signed in";
    }on FirebaseAuthException catch(e){
      return e.message!;
    }
  }

  Future<String> signUp({String? email, String? password}) async{
    try{
      await firebaseAuth.createUserWithEmailAndPassword(email: email!, password: password!);
      print("Signed up");
      return "Signed Up";
    }on FirebaseAuthException catch(e){
      return e.message!;
    }
  }

  Future<String> signOut() async{
    try{
      await firebaseAuth.signOut();
      print("Signed out");
      return "Signed out";
    }on FirebaseAuthException catch(e){
      return e.message!;
    }
  }


}