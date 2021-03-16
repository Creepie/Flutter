import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/login/widgets/login_form.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/cubits/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(listener: (context, state) {
        //If the user logged in, and the Authentication was successful, clear
        // the route stack and go to HomeViewRoute
        if (state is AuthAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, AppRouter.HomeViewRoute,
              (Route<dynamic> route) => false);
        }
      }, child: Center(child: LoginForm()
      ))
    );
  }
}
