import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/routs.dart';
import 'package:flutter_onboarding/screens/splash/splash_screen.dart';

void main() => runApp(MyApp());

///in this class the Program starts with the first Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///don't show the debug Banner on the top right corner
      debugShowCheckedModeBanner: false,
      title: 'OnBoarding',
      ///set some theme attributes
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "Muli",
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kTextColor),
          bodyText2: TextStyle(color: kTextColor),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SplashScreen(),
      ///the app always shows the SplashScreen at the start cause of the route
      initialRoute: SplashScreen.routeName,
      routes: routes,
    ); 
  }
}

