import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

// Handles the communication with the database, concerning the user.
class UserRepository {
  FirebaseDatabase database;
  DatabaseReference userDb;

  ///Constructor of the UserRepository
  ///here the database reference is set
  UserRepository(){
    database = FirebaseDatabase();
    userDb = database.reference().child('Users');
  }

  ///this method adds a new entry into the Users table on the firebase database
  ///param [user] is the user which get stored in the db
  Future<bool> addUserToDB(DBUser user) async {
    var test = await userDb.child(user.uid).set(user.toJson());
    return Future.value(true);
  }

  ///this method checks the phonebook and search for each [Contact] in it in the userDB
  ///if a
  Future<bool> addFavouritesToUser(DBUser user) async {
    var userNew = user;
    int count = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();

    for(int i=0; i<_contacts.length; i++ ){
      DataSnapshot contact = await userDb.orderByChild('number').equalTo(_contacts[i].displayName).once();

      if(contact.value != null){
        Map<dynamic, dynamic>.from(contact.value).forEach((key,values) {
          var user = DBUser.fromJson(values);
          userNew.favourites.add(user.uid);
          count++;
        });
      }

    }
    if(count > 0){
      var test = await userDb.child(userNew.uid).set(user.toJson());
    }
    return true;
  }

  ///this method gets a user from the firebase db after he start the app
  ///param [uid] is the unique firebase identifier of the user
  ///returns [DBUser] object
  Future<DBUser> getUserFromDB(String uid) async {
    DataSnapshot user = await userDb
        .child(uid)
        .once();
    return Future.value(DBUser.fromJson(user.value));
    }
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
    return DBUser("mail", "name", token, null, null);
  }

  Future<bool> logIn() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<String> createUser({String username, String password}) async {
    await Future.delayed(Duration(seconds: 2));
    return null;
  }
