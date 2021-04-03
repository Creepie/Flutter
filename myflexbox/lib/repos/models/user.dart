import 'package:firebase_auth/firebase_auth.dart';

class DBUser {
  String email;
  String name;
  String token;
  User firebaseUser;

  DBUser(this.email, this.name, this.token, this.firebaseUser);
}