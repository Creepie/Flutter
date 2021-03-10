
import 'package:flutter/material.dart';

///this class represent the beginning of the LoginScreen (dummy)
class LoginScreen extends StatelessWidget {
  ///set a route to the loginScreen
  static String routeName = "/login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Im Login Screen'),
      ),
    );
  }
}
