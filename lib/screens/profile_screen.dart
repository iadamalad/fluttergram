import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/screens/edit_profile_screen.dart';
import 'package:fluttergram/utilities/constants.dart';
import 'package:fluttergram/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
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
                                    "386",
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
                                    "345",
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
                          Container(
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
                          ),
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
