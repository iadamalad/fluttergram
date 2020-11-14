import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
    });
    //from the usersRef (user collection), we will choose a specefic document
  }

  static Future<QuerySnapshot> searchUser(String name) {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .getDocuments(); //find all users whose name is equal or longer to the name passed in
    return users;
  }
}
