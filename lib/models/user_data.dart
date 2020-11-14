import 'package:flutter/foundation.dart';

//use ChangeNotifier to allow UI to listen to change in UserData class
class UserData extends ChangeNotifier {
  String currentUserId;
}
