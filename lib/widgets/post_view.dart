import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/comment_screen.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/services/database_service.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;

  PostView({this.currentUserId, this.post, this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    // _setupLikeCount();
    _setupIsLiked();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount;
    }
  }

  _setupIsLiked() async {
    bool isLiked = await DatabaseService.didLikePost(
        currentUserId: widget.currentUserId, post: widget.post);
    if (mounted) {
      //if(mounted) ensures the widget is in the tree before setting state
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() {
    if (_isLiked) {
      DatabaseService.unlikePost(
          currentUserId: widget.currentUserId, post: widget.post);
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      DatabaseService.likePost(
          currentUserId: widget.currentUserId, post: widget.post);
    }
    setState(() {
      _heartAnim = true;
      _isLiked = true;
      _likeCount = _likeCount + 1;
    });
    Timer(Duration(milliseconds: 350), () {
      setState(() {
        _heartAnim = false;
      });
    });
  }

  // _setupLikeCount() async {
  //   DocumentSnapshot postSnapshot = await postsRef
  //       .document(widget.post.authorId)
  //       .collection("userPosts")
  //       .document(widget.post.id)
  //       .get();
  //   int likeCount = postSnapshot.data['likeCount'];
  //   setState(() {
  //     _likeCount = likeCount;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: widget.post.authorId),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: widget.author.profileImageUrl.isEmpty
                      ? AssetImage('assets/images/user-placeholder.jpg')
                      : CachedNetworkImageProvider(
                          widget.author.profileImageUrl),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(widget.author.name,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600))
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: _likePost,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.imageUrl),
                    fit: BoxFit
                        .cover, //used in case images are cropped so they expand to whole square
                  ),
                ),
              ),
              _heartAnim
                  ? Animator(
                      duration: Duration(milliseconds: 300),
                      tween: Tween(begin: 0.5, end: 1.4),
                      curve: Curves.elasticOut,
                      builder: (context, anim, child) => Transform.scale(
                        scale: anim.value,
                        child: Icon(
                          Icons.favorite,
                          size: 100.0,
                          color: Colors.red[400],
                        ),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: _isLiked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 32,
                          )
                        : Icon(
                            Icons.favorite_border_rounded,
                            size: 32,
                          ),
                    onPressed: _likePost,
                  ),
                  IconButton(
                    icon: Icon(Icons.comment_rounded, size: 32),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CommentScreen(
                                  post: widget.post,
                                  likeCount: _likeCount,
                                ))),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${_likeCount.toString()}likes",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12.0, right: 6.0),
                    child: Text(
                      widget.author.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.post.caption,
                      style: TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
