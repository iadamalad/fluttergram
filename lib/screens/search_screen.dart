import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController =
      TextEditingController(); //allows us to see and modify text in text field

  Future<QuerySnapshot> _users;

  Widget _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage("assets/images/user-placeholder.jpg")
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(user.name),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: user.id,
          ),
        ),
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
    });

    setState(() {
      _users = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                filled: true,
                border: InputBorder.none,
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _clearSearch();
                  },
                )),
            onSubmitted: (input) {
              setState(() {
                if (input.isNotEmpty) {
                  _users = DatabaseService.searchUser(input);
                }
              });
            },
          )),
      body: _users == null
          ? Center(
              child: Text("Search for user"),
            )
          : FutureBuilder(
              future: _users,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents.length == 0) {
                  //no users returned in search
                  return Center(
                    child: Text("No users found!"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    //take the snapshot data and make a user
                    User user = User.fromDoc(snapshot.data.documents[index]);
                    return _buildUserTile(user);
                  },
                );
              },
            ),
    );
  }
}
