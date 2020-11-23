import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_data.dart';
import 'package:fluttergram/screens/activity_screen.dart';
import 'package:fluttergram/screens/create_post_screen.dart';
import 'package:fluttergram/screens/feed_screen.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
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
      body: PageView(
        controller: _pageController,
        children: [
          FeedScreen(currentUserId: Provider.of<UserData>(context).currentUserId),
          SearchScreen(),
          CreatePostScreen(),
          ActivityScreen(),
          //we have to pass in the UserId into the ProfileScreen because
          //we might want to render other Profiles from Search
          ProfileScreen(
            currentUserId: Provider.of<UserData>(context).currentUserId,
            userId: Provider.of<UserData>(context).currentUserId,
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
