

import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{
  String token = '';
  String get _token => token;
  void setToken(String val){
    token = val;
    notifyListeners();
  }

}