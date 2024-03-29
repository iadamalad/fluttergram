import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttergram/models/user_data.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _store = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _store
            .collection("users")
            .document(signedInUser.uid)
            .setData({'name': name, 'email': email, 'profile-pic': ""});
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void signOutUser() {
    _auth.signOut();
    //Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  static void signInUser(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }

    // try {
    //   AuthResult authResult = await _auth.signInWithEmailAndPassword(
    //       email: email, password: password);
    //   FirebaseUser signedInUser = authResult.user;
    //   print("Logged in Successfully");
    // } catch (e) {
    //   print("Cannot log in");
    // }
  }
}
