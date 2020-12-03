import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_data.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/edit_profile_screen.dart';
import 'package:fluttergram/services/auth_service.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/utilities/constants.dart';
import 'package:fluttergram/widgets/post_view.dart';
import 'package:provider/provider.dart';

import 'comment_screen.dart';

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
  List<Post> _posts = [];
  int _displayPost = 0;
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowerCount();
    _setupFollowingCount();
    _setupPosts();
    _setupProfileUser();
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

  _setupPosts() async {
    List<Post> userPosts = await DatabaseService.getUserPosts(widget.userId);
    print("Length of userposts: " + userPosts.length.toString());
    setState(() {
      _posts = userPosts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await DatabaseService.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
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

  _buildProfileInfo(User user) {
    return (Column(
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
                              _posts.length.toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(height: 80, child: Text(user.bio)),
              Divider(),
            ],
          ),
        )
      ],
    ));
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          iconSize: 30,
          icon: Icon(Icons.apps_rounded,
              color: _displayPost == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey),
          onPressed: () => setState(() {
            _displayPost = 0;
          }),
        ),
        IconButton(
          iconSize: 30,
          icon: Icon(
            Icons.list,
            color: _displayPost == 1
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
          onPressed: () => setState(() {
            _displayPost = 1;
          }),
        )
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
        child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommentScreen(
            post: post,
            likeCount: post.likeCount,
          ),
        ),
      ),
      child: Image(
          image: CachedNetworkImageProvider(post.imageUrl), fit: BoxFit.cover),
    ));
  }

  _buildDisplayPosts() {
    if (_displayPost == 0) {
      List<GridTile> tiles = [];
      _posts.forEach(
        (post) => tiles.add(_buildTilePost(post)),
      );
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser));
      });
      return Column(
        children: postViews,
      );
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: AuthService.signOutUser,
          )
        ],
      ),
      body: FutureBuilder(
        future: usersRef.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: [
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
