import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

// Handles the communication with the database, concerning the user.
class UserRepository {
  FirebaseDatabase database;
  DatabaseReference userDb;

  UserRepository(){
    database = FirebaseDatabase();
    userDb = database.reference().child('Users');
  }




  Future<bool> addUserInDB(DBUser user) async {
    var test = await userDb.child(user.uid).set(user.toJson());
    return Future.value(true);
  }

  Future<DBUser> getUserInDB(String uid) async {
    Completer<DBUser> completer = new Completer<DBUser>();
    
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .orderByChild("uid")
        .equalTo(uid)
        .once()
        .then((DataSnapshot snapshot) {
      var user = new DBUser.fromJson(snapshot.value);
      completer.complete(user);
    });
    return completer.future;
  }


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
    return DBUser("mail", "name", token, null);
  }

  Future<bool> logIn() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<String> createUser({String username, String password}) async {
    await Future.delayed(Duration(seconds: 2));
    return null;
  }
}