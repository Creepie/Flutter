
import 'package:flutter/widgets.dart';
import 'profile_screen.dart';

///this map is global available and saves all possible routes of the app
final Map<String, WidgetBuilder> routes = {
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
