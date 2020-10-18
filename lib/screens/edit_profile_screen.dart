import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/utilities/constants.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String _profileImageUrl = '';
      User user = User(
          id: widget.user.id,
          name: _name,
          profileImageURL: _profileImageUrl,
          bio: _bio);

      //Database update
      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/4d/fb/01/4dfb011a-62c9-6369-6343-58f4cf7cf8be/AppIcon-0-1x_U007emarketing-0-85-220-0-7.png/1024x1024bb.jpg'),
                    ),
                    FlatButton(
                      onPressed: () => print("change profile image"),
                      child: Text(
                        "Change Profile Image",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, size: 30),
                        labelText: "Name",
                      ),
                      validator: (input) => input.trim().length < 1
                          ? "Please input a proper name"
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.book,
                          size: 30,
                        ),
                        labelText: "Bio",
                      ),
                      validator: (input) => input.trim().length > 150
                          ? "Please input a shorter bio"
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Container(
                      margin: EdgeInsets.all(40.0),
                      height: 40,
                      width: 250,
                      child: FlatButton(
                        onPressed: _save,
                        child: Text("Save"),
                        color: Colors.blue,
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
