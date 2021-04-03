import 'package:firebase_auth/firebase_auth.dart';

class DBUser {
  String email;
  String name;
  String token;
  String uid;

  DBUser(this.email, this.name, this.token, this.uid);
  DBUser.json({this.email, this.name, this.token, this.uid});

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'token' : token,
        'uid' : uid,
      };

  factory DBUser.fromJson(Map<dynamic,dynamic> json){
    return DBUser.json(
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      uid: json['uid'] as String
    );
  }
}