import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_data.dart';
import 'package:fluttergram/screens/edit_profile_screen.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/utilities/constants.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;
  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowerCount();
    _setupFollowingCount();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowerCount() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    setState(() {
      _followerCount = userFollowerCount;
    });
  }

  _setupFollowingCount() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 200,
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    user: user,
                  ),
                ),
              ).then((value) {
                setState(() {});
              }),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text(
                "Edit Profile",
              ),
            ),
          )
        : Container(
            width: 200,
            child: FlatButton(
              onPressed: _followOrUnfollow,
              textColor: _isFollowing ? Colors.black : Colors.white,
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
              child: Text(
                _isFollowing ? "Unfollow" : "Follow",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
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
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage("assets/images/user-placeholder.jpg")
                          : CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "12",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "posts",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    _followerCount.toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "followers",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    _followingCount.toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "following",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  )
                                ],
                              )
                            ],
                          ),
                          _displayButton(user),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 80, child: Text(user.bio)),
                    Divider(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
