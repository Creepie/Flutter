import 'package:flutter/material.dart';

import 'models/user.dart';

// Handles the communication with the database, concerning the user.
class UserRepository {

  //Check if LogIn Data is correct and return Token, null otherwise
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return "";
  }

  //Return Token if the user is logged in, null otherwise
  Future<String> hasToken() async {
    await Future.delayed(Duration(seconds: 3));
    return "";
}

  Future<DBUser> getUser(String token) async {
    await Future.delayed(Duration(seconds: 2));
    return DBUser("mail", "name", token, "");
  }

  Future<bool> logIn() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<String> register({String username, String password}) async {
    await Future.delayed(Duration(seconds: 2));
    return null;
  }
}