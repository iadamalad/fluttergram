import 'package:fluttergram/models/user_model.dart';
import 'package:fluttergram/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageURL,
      'bio': user.bio,
    });
    //from the usersRef (user collection), we will choose a specefic document
  }
}
