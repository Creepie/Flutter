import 'package:firebase_auth/firebase_auth.dart';

class DBUser {
  String email;
  String name;
  String token;
  UserCredential firebaseUser;

  DBUser(this.email, this.name, this.token, this.firebaseUser);
}