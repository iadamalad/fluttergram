import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final usersRef = _firestore.collection(
    'users'); //this allows us to use the userRef throughout the entire app
final storageRef = FirebaseStorage.instance
    .ref(); //makes reference to the root of our database on Google
