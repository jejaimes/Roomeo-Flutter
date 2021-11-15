import 'package:flutter/cupertino.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel();

  late String email;

  String getEmail() {
    return email;
  }

  void setEmail(String pEmail) {
    email = pEmail;
    notifyListeners();
  }
}
