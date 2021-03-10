import 'package:flutter/material.dart';
import 'package:flutter_onboarding/screens/splash/components/body.dart';
import 'package:flutter_onboarding/size_config.dart';


class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    ///init the SizeConfig class for height and weight calc methods
    SizeConfig().init(context);
    ///A Scaffold Widget provides a framework which implements the basic material
    /// design visual layout structure of the flutter app.
    /// It provides APIs for showing drawers, snack bars and bottom sheets.
    /// In a Scaffold you can add for example a button navigation bar
    return Scaffold(
      ///Body() is a Widget class which can be found at screens/splash/components
      body: Body(),
    );
  }

}