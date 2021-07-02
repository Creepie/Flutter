import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'config/app_router.dart';
import 'cubits/auth/auth_cubit.dart';
import 'package:myflexbox/config/constants.dart';


// Entry Point for the application. The MyApp Widget is started here
void main() {
  runApp(MyApp());
}

// This is the root widget.
// The root widget in flutter should be MaterialApp. (has useful functionality
// like routing.)
// In this case, the MaterialApp is wrapped with a BlocProvider. The reason for
// that is, that the AuthCubit and the AuthState should be available in all
// widgets in the App (available via BlocListener or BlocConsumer), no matter
// in which route.
class MyApp extends StatelessWidget {
  //An instance of the AppRouter is implemented
  //In the MaterialApp Widget, the onGenerateRoute is set to the generateRoute
  //method of this class.
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The AuthCubit is initialized and a newly created
      // UserRepository Object is passed in the constructor.
      // After initialisation, the authenticate() method is immediately called
      // This method checks whether the user is already logged in or not.
      create: (context) => AuthCubit(UserRepository())..authenticate(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor
        ),
        title: 'MYFLEXBOX',
        onGenerateRoute: _appRouter.generateRoute,
      ),
    );
  }
}

