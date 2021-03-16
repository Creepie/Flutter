import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/home_screen.dart';
import 'package:myflexbox/Screens/login/login_screen.dart';
import 'package:myflexbox/Screens/onboarding/onboarding_screen.dart';
import 'package:myflexbox/Screens/register/register_screen.dart';
import 'package:myflexbox/Screens/start/start_screen.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_cubit.dart';
import 'package:myflexbox/cubits/login/login_cubit.dart';
import 'package:myflexbox/cubits/register/register_cubit.dart';
import 'package:myflexbox/repos/user_repo.dart';

class AppRouter {
  static const String StartViewRoute = '/';
  static const String LoginViewRoute = 'login';
  static const String HomeViewRoute = 'home';
  static const String RegisterViewRoute = 'register';
  static const String OnBoardingRoute = 'onboarding';

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StartViewRoute:
        return MaterialPageRoute(builder: (context) => StartPage());

      case LoginViewRoute:
        var arguments = settings.arguments as Map;
        AuthCubit authCubit = arguments["authCubit"];
        UserRepository userRepository = arguments["userRepository"];
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => LoginCubit(
                    authCubit: authCubit, userRepository: userRepository),
                child: LoginScreen()));

      case RegisterViewRoute:
        var arguments = settings.arguments as Map;
        UserRepository userRepository = arguments["userRepository"];
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) =>
                    RegisterCubit(userRepository: userRepository),
                child: RegisterPage()));

      case HomeViewRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (context) => BottomNavCubit(), child: HomeScreen()),
        );

      case OnBoardingRoute:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());

      default:
        return MaterialPageRoute(builder: (context) => StartPage());
    }
  }
}
