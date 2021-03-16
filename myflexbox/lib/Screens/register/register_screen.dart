import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/register/widgets/register_form.dart';
import 'package:myflexbox/Screens/register/widgets/register_success_view.dart';
import 'package:myflexbox/cubits/register/register_cubit.dart';
import 'package:myflexbox/cubits/register/register_state.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(body: Center(
      child:
          BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
        if (state is RegisterSuccess) {
          return RegisterSuccessView();
        } else {
          return RegisterForm();
        }
      }),
    ));
  }
}
