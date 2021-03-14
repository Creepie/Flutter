import 'package:flutter/material.dart';
import 'package:flutter_profile/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
        ),
        ///is a widget class
        body: Body(),
      );
  }
}