import 'package:flutter/material.dart';
import 'routes.dart';
import 'profile_screen.dart';
import 'theme.dart';

void main() => runApp(MyApp());

///in this class the Program starts with the first Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///don't show the debug Banner on the top right corner
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
          ///theme makes the banner on top white also defines font family,...
          theme: theme(),
      ///We use routeName so that we dont need to remember the name
      ///app starts at profilescreen
      initialRoute: ProfileScreen.routeName,
      routes: routes,
      );
  }
}