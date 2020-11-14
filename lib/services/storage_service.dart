import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttergram/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4(); //generates a random photo id
    File image = await compressImage(
        photoId, imageFile); //compress the image using the compress function

    if (url.isNotEmpty) {
      //we are passing in a url so we are updating the profile picture
      RegExp exp = RegExp(r'userProfile_(.*).jpg'); //choose what's in the star
      print(exp.firstMatch(url));
      photoId = exp.firstMatch(url)[1];
      print(photoId);
    }
    print("Uploading....");
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask
        .onComplete; //this is what's returned from our uploadTask
    String downloadUrl = await storageSnap.ref
        .getDownloadURL(); //gets the url that is stored on Firebase Storage
    return downloadUrl;
  }

  static Future<String> uploadPost(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask =
        storageRef.child('images/posts/post_$photoId.jpg').put(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir =
        await getTemporaryDirectory(); //uses path provider to create temporary directory so we can store the image
    final path = tempDir.path;
    File compressedImage = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, '$path/img_$photoId.jpg',
        quality: 70);
    return compressedImage;
  }
}
