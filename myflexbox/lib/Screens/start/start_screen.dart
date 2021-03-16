import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/start/widgets/splash_view.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/cubits/auth/auth_state.dart';

class StartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //BlocConsumer: Listens for the a State change of the AuthState
    return BlocConsumer<AuthCubit, AuthState>(
          //listener: for logic, no widgets are returned
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              //state is: AuthAuthenticated -> authentication successful
              // push the HomeViewRoute and remove this page from the rout-stack
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.HomeViewRoute, (Route<dynamic> route) => false);
            } else if (state is AuthUnauthenticated) {
              //state is: AuthUnauthenticated -> authentication unsuccessful
              // push the LoginViewRoute and remove this page from the rout-stack
              // pass the arguments to the route (see the Route file)
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.OnBoardingRoute, (Route<dynamic> route) => false);
            }
          },
          //builder: returns the widget, depending on the state
          builder: (BuildContext context, AuthState state) {
            if (state is AuthUninitialized) {
              return SplashView();
            }else if (state is AuthLoading) {
              return SplashView();
            }
            return SplashView();
          }
        );
  }

}