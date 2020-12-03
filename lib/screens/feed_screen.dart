import 'package:flutter/material.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static String id = "FEEDSCREEN";
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.black, fontSize: 35),
        ),
      ),
      body: _posts.length > 0
          ? RefreshIndicator(
              onRefresh: () => _setupFeed(),
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _posts[index];
                  return FutureBuilder(
                    future: DatabaseService.getUserWithId(post.authorId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      User author = snapshot.data;
                      return PostView(
                          currentUserId: widget.currentUserId,
                          post: post,
                          author: author);
                    },
                  );
                },
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
