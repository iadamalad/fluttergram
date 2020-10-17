import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/screens/activity_screen.dart';
import 'package:fluttergram/screens/create_post_screen.dart';
import 'package:fluttergram/screens/feed_screen.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({this.userId});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.black, fontSize: 35),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FeedScreen(),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          ProfileScreen(
            userId: widget.userId,
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 32)),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications, size: 32)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 32))
        ],
      ),
    );
  }
}
