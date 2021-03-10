

import 'package:flutter/widgets.dart';
import 'package:flutter_onboarding/screens/login/login_screen.dart';
import 'package:flutter_onboarding/screens/splash/splash_screen.dart';

///this map is global available and saves all possible routes of the app
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
};


