import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
      id: '',
      name: 'guest@gmail.com',
      email: 'guest@gmail.com',
      role: UserRole.guest,
      );

  UserModel get user => _user;


  void setUserFromModel(UserModel user) {
    _user = user;
  }

  void logOut() {
    _user = UserModel(
      id: '',
      name: 'guest',
      email: 'guest@gmail.com',
      role: UserRole.guest,
      );
    notifyListeners();
  }
}