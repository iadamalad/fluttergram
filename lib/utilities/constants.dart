import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
final usersRef = _firestore.collection(
    'users'); //this allows us to use the userRef throughout the entire app
