import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String id;
  final String profileImageUrl;
  final String bio;
  final String email;

  User({this.name, this.id, this.profileImageUrl, this.bio, this.email});

  factory User.fromDoc(DocumentSnapshot doc) {
    //takes the snapshot and creates the user
    return User(
      name: doc['name'],
      id: doc.documentID,
      profileImageUrl: doc['profileImageUrl'] ?? "",
      bio: doc['bio'] ?? "",
      email: doc['email'],
    );
  }
}
