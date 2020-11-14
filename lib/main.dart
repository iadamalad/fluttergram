import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/screens/login_screen.dart';
import 'package:fluttergram/screens/signup_screen.dart';
import 'package:fluttergram/screens/feed_screen.dart';
import 'package:fluttergram/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget _getScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: MaterialApp(
        title: "Fluttergram",
        debugShowCheckedModeBanner: false,
        home: _getScreen(),
        theme: ThemeData(
            primaryIconTheme: Theme.of(context)
                .primaryIconTheme
                .copyWith(color: Colors.black)),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          FeedScreen.id: (context) => FeedScreen(),
        },
      ),
    );
  }
}
