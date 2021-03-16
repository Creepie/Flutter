import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/cubits/login/login_cubit.dart';
import 'package:myflexbox/cubits/login/login_state.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(width: 250, child: EmailFormField()),
        SizedBox(
          height: 20,
          width: 40,
        ),
        Container(
          width: 250,
          child: PasswordFormField(),
        ),
        SizedBox(
          height: 20,
          width: 40,
        ),
        LoginButton(),
        RegisterButton(),
      ],
    );
  }
}


class EmailFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        onChanged: (String email) {
          var loginCubit = context.read<LoginCubit>();
          loginCubit.changedEmail(email);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "E-Mail",
          errorText: state.email.error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is LoginFailure ? Colors.red : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is LoginFailure ? Colors.red : Colors.grey,
            ),
          ),
          errorStyle: TextStyle(
            color: state is LoginFailure ? Colors.red : Colors.grey,
          ),
        ),
      );
    });
  }
}

class PasswordFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        onChanged: (String email) {
          var loginCubit = context.read<LoginCubit>();
          loginCubit.changedPassword(email);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          errorText: state.password.error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is LoginFailure ? Colors.red : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is LoginFailure ? Colors.red : Colors.grey,
            ),
          ),
          errorStyle: TextStyle(
            color: state is LoginFailure ? Colors.red : Colors.grey,
          ),
        ),
      );
    });
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      bool canSubmit = state.email.error == null
          && state.password.error == null
          && state.password.text != null
          && state.email.text != null;
      if (state is LoadingLoginState) {
        return CircularProgressIndicator();
      } else {
        return FlatButton(
          padding: EdgeInsets.only(left: 100, right: 100),
          child: Text(
            "login",
            style: TextStyle(
              color: canSubmit? Colors.white: Colors.blue,
            ),
          ),
          color: canSubmit? Colors.blue: Colors.black12 ,
          onPressed: () {
            FocusScope.of(context).unfocus();
            var loginCubit = context.read<LoginCubit>();
            if (canSubmit) {
              loginCubit.login();
            } else {
              loginCubit.invalidInput();
            }
          },
        );
      }
    });
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return FlatButton(
        child: Text(
          "create an account",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          var loginCubit = context.read<LoginCubit>();
          var arguments = {"userRepository": loginCubit.userRepository};
          Navigator.pushNamed(buildContext, AppRouter.RegisterViewRoute,
              arguments: arguments);
        },
      );
    });
  }
}
