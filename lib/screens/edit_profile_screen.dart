import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/screens/profile_screen.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/services/storage_service.dart';
import 'package:fluttergram/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  File _profileImage; //this is the image thats picked from the user's gallery
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  _displayProfileImage() {
    //no new profile image
    if (_profileImage == null) {
      //no existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage("assets/images/user-placeholder.jpg");
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  _save() async {
    if (_formKey.currentState.validate() && !_isLoading) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
      );

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        backgroundImage: _displayProfileImage(),
                      ),
                      FlatButton(
                        onPressed: _handleImageFromGallery,
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
          ],
        ),
      ),
    );
  }
}
