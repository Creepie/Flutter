import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'config/app_router.dart';
import 'cubits/auth/auth_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(UserRepository())..authenticate(),
      child: MaterialApp(
        title: 'MYFLEXBOX',
        onGenerateRoute: _appRouter.generateRoute,
      ),
    );
  }
}

