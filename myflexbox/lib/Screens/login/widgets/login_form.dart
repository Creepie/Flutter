import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/config/app_router.dart';
import 'package:myflexbox/cubits/login/login_cubit.dart';
import 'package:myflexbox/cubits/login/login_state.dart';

//Login Form Widget
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

// Email input field
class EmailFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        // OnChangedListener
        onChanged: (String email) {
          //the changedEmail Method of the loginCubit is called
          var loginCubit = context.read<LoginCubit>();
          loginCubit.changedEmail(email);
        },
        // Style Attributes
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "E-Mail",
          // The error string is obtained from the email object that is stored
          // in the loginState
          //  Depending on the State, different Colors are used
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

// Password input field
class PasswordFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return TextFormField(
        // OnChangedListener
        onChanged: (String email) {
          var loginCubit = context.read<LoginCubit>();
          loginCubit.changedPassword(email);
        },
        // Style Attributes
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          // The error string is obtained from the password object that is stored
          // in the loginState
          //  Depending on the State, different Colors are used
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

//Login Button
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      //Here, it is checked, whether all fields are filled and there is no error
      bool canSubmit = state.email.error == null
          && state.password.error == null
          && state.password.text != null
          && state.email.text != null;
      if (state is LoadingLoginState) {
        // While loading, a progress-indicator is displayed
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
            //Depending on the canSubmit bool, the press leads to different
            // method calls of the loginCubit
            FocusScope.of(context).unfocus(); //Hide Keyboard
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

// Register Button
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
          // The Register Route is pushed, and the userRepository is
          // passed as argument.
          var loginCubit = context.read<LoginCubit>();
          var arguments = {"userRepository": loginCubit.userRepository};
          Navigator.pushNamed(buildContext, AppRouter.RegisterViewRoute,
              arguments: arguments);
        },
      );
    });
  }
}
