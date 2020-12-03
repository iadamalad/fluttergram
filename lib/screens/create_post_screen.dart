import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/post_model.dart';
import 'package:fluttergram/models/user_data.dart';
import 'package:fluttergram/services/database_service.dart';
import 'package:fluttergram/services/storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  TextEditingController _catpionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text("Add Photo"),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () => _handleImage(ImageSource.camera),
                child: Text('Take Photo'),
              ),
              CupertinoActionSheetAction(
                onPressed: () => _handleImage(ImageSource.gallery),
                child: Text('Upload Photo'),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Add Photo"),
            children: [
              SimpleDialogOption(
                onPressed: () => _handleImage(ImageSource.camera),
                child: Text("Take Photo"),
              ),
              SimpleDialogOption(
                onPressed: () => _handleImage(ImageSource.gallery),
                child: Text("Upload Photo"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ],
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    return croppedImage;
  }

  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      //create post

      String imageUrl = await StorageService.uploadPost(_image);

      Post post = Post(
        imageUrl: imageUrl,
        caption: _caption,
        likeCount: 0,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );

      DatabaseService.createPost(post);

      _catpionController.clear();
      setState(() {
        _caption = "";
        _isLoading = false;
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Create Post",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _submit,
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: height,
              child: Column(
                children: <Widget>[
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.blue[200],
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        )
                      : SizedBox.shrink(),
                  GestureDetector(
                    onTap: _showSelectImageDialog,
                    child: Container(
                      height: width,
                      width: width,
                      color: Colors.grey[300],
                      child: _image == null
                          ? Icon(Icons.add_a_photo,
                              color: Colors.white, size: 150)
                          : Image(
                              image: FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _catpionController,
                      decoration: InputDecoration(
                        hintText: "Caption",
                      ),
                      onChanged: (input) => _caption = input,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
