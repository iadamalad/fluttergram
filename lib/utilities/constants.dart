import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

//this allows us to use the userRef throughout the entire app
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection("posts");
final followersRef = _firestore.collection("followers");
final followingRef = _firestore.collection("following");
final feedsRef = _firestore.collection("feeds");
final likesRef = _firestore.collection("likes");
final commentsRef = _firestore.collection("comments");
final activitiesRef = _firestore.collection("activities");

//makes reference to the root of our database on Google
final storageRef = FirebaseStorage.instance.ref();
