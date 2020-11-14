import 'package:flutter/material.dart';
import 'package:fluttergram/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static String id = "FEEDSCREEN";
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.black, fontSize: 35),
        ),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () => AuthService.signOutUser(context),
          child: Text("Logout"),
        ),
      ),
    );
  }
}
