import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/register/register_cubit.dart';
import 'package:myflexbox/cubits/register/register_state.dart';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(width: 250, child: UsernameFormField()),
        SizedBox(
          height: 20,
          width: 40,
        ),
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

class UsernameFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return TextFormField(
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        onChanged: (String username) {
          var registerCubit = context.read<RegisterCubit>();
          registerCubit.changedUsername(username);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          errorText: state.username.error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.grey,
            ),
          ),
          errorStyle: TextStyle(
            color: state is RegisterFailure ? Colors.red : Colors.grey,
          ),
        ),
      );
    });
  }
}


class EmailFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return TextFormField(
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        onChanged: (String email) {
          var loginCubit = context.read<RegisterCubit>();
          loginCubit.changedEmail(email);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "E-Mail",
          errorText: state.email.error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.grey,
            ),
          ),
          errorStyle: TextStyle(
            color: state is RegisterFailure ? Colors.red : Colors.grey,
          ),
        ),
      );
    });
  }
}

class PasswordFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return TextFormField(
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        onChanged: (String email) {
          var registerCubit = context.read<RegisterCubit>();
          registerCubit.changedPassword(email);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          errorText: state.password.error,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state is RegisterFailure ? Colors.red : Colors.grey,
            ),
          ),
          errorStyle: TextStyle(
            color: state is RegisterFailure ? Colors.red : Colors.grey,
          ),
        ),
      );
    });
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      bool canSubmit = state.email.error == null
          && state.password.error == null
          && state.password.text != null
          && state.email.text != null
          && state.username.error != null
          && state.username.text != null;
      if (state is RegisterLoadingState) {
        return CircularProgressIndicator();
      } else {
        return FlatButton(
          padding: EdgeInsets.only(left: 100, right: 100),
          child: Text(
            "register",
            style: TextStyle(
                color: canSubmit? Colors.white: Colors.blue ,
            ),
          ),
          color: canSubmit? Colors.blue: Colors.black12 ,
          onPressed: () {
            FocusScope.of(context).unfocus();
            var registerCubit = context.read<RegisterCubit>();
            if (canSubmit) {
              registerCubit.register();
            } else {
              registerCubit.invalidInput();
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
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return FlatButton(
        child: Text(
          "back to login",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          var registerCubit = context.read<RegisterCubit>();
          Navigator.pop(buildContext);
        },
      );
    });
  }
}
