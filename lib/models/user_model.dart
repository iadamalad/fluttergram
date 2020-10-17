import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String id;
  final String profileImageURL;
  final String bio;
  final String email;

  User({this.name, this.id, this.profileImageURL, this.bio, this.email});

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      id: doc.documentID,
      profileImageURL: doc['profileImageURL'],
      bio: doc['bio'] ?? "",
      email: doc['email'],
    );
  }
}
