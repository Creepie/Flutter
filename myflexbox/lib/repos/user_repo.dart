import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myflexbox/config/constants.dart';

import 'models/user.dart';

// Handles the communication with the database, concerning the user.
class UserRepository {
  FirebaseDatabase database;
  DatabaseReference userDb;

  ///Constructor of the UserRepository
  ///here the database reference is set
  UserRepository() {
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
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();

    List<String> numberList = [];

    for (int i = 0; i < _contacts.length; i++) {
      var contactNumbers = _contacts[i].phones.toList();
      for (int j = 0; j < _contacts[i].phones.length; j++) {
        numberList.add(contactNumbers[j].value.replaceAll(" ", ""));
      }
    }

    for (int i = 0; i < numberList.length; i++) {
      if (numberList[i].isNotEmpty) {
        addFavouriteToFirebase(numberList[i],user);
      }
    }

    return Future.value(true);
  }
  
  Future<void> addFavouriteToFirebase(String number, DBUser user) async {
    DataSnapshot contact =
    await userDb.orderByChild('number').equalTo(number).once();
    print('favouriteAdded');
    if (contact.value != null) {
      Map<dynamic, dynamic>.from(contact.value).forEach((key, values) {
        userDb.child(user.uid).child("favourites").set({key:key});
      });
    }
  }

  ///this method query all favourite [DBUser] and saves it into [favouriteContacts] for global usage
  Future<void> getFavouriteUsers(String uid) async {
    DBUser myUser = await getUserFromDB(uid);

    for (int i = 0; i < myUser.favourites.length; i++) {
      DBUser user = await getUserFromDB(myUser.favourites[i]);
      if (user != null) {
        favouriteContacts.add(user);
      }
    }
  }

  ///this method gets a user from the firebase db after he start the app
  ///param [uid] is the unique firebase identifier of the user
  ///returns [DBUser] object
  Future<DBUser> getUserFromDB(String uid) async {
    DataSnapshot user = await userDb.child(uid).once();
    if (user.value != null) {
      return Future.value(DBUser.fromJson(user.value));
    } else {
      return Future.value(null);
    }
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
