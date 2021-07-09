

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_final/Screens/starting.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  String message = '';

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
        print(message);
        return null;
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
        print(message);
        return null;
      }
    } catch (e) {
      message = e.toString();
      print(message);
      return null;
    }
  }

  void signOut(context) {
    auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GettingStarted()));
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
        return null;
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
        return null;
      } else {
        message = 'Invalid Details';
        return null;
      }
    }
  }
}