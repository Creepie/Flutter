import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/register/register_cubit.dart';
import 'package:myflexbox/cubits/register/register_state.dart';

//Register Form Widget
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

//Username Form Field
class UsernameFormField extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return TextFormField(
        // OnChangedListener
        onChanged: (String username) {
          //the changedUserName method of the RegisterCubit is called
          var registerCubit = context.read<RegisterCubit>();
          registerCubit.changedUsername(username);
        },
        // Style Attributes
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          // The error string is obtained from the username object that is stored
          // in the registerState
          //  Depending on the State, different Colors are used
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
        // OnChangedListener
        onChanged: (String email) {
          //the changedEmail method of the RegisterCubit is called
          var loginCubit = context.read<RegisterCubit>();
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
          // in the registerState
          //  Depending on the State, different Colors are used
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
        // OnChangedListener
        onChanged: (String email) {
          //the changedPassword method of the RegisterCubit is called
          var registerCubit = context.read<RegisterCubit>();
          registerCubit.changedPassword(email);
        },
        // Style Attributes
        textCapitalization: TextCapitalization.none,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
          // The error string is obtained from the error object that is stored
          // in the registerState
          //  Depending on the State, different Colors are used
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
      //Here, it is checked, whether all fields are filled and there is no error
      bool canSubmit = state.email.error == null
          && state.password.error == null
          && state.password.text != null
          && state.email.text != null
          && state.username.error == null
          && state.username.text != null;
      if (state is RegisterLoadingState) {
        // While loading, a progress-indicator is displayed
        return SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 4,
          ),
          height: 30.0,
          width: 30.0,

        );
      } else {
        return SizedBox(
          width: 250,
          child: FlatButton(
            child: Text(
              "register",
              style: TextStyle(
                  color: canSubmit? Colors.white: Colors.blue ,
              ),
            ),
            color: canSubmit? Colors.blue: Colors.black12 ,
            onPressed: () {
              //Depending on the canSubmit bool, the press leads to different
              // method calls of the registerCubit
              FocusScope.of(context).unfocus();
              var registerCubit = context.read<RegisterCubit>();
              if (canSubmit) {
                registerCubit.register();
              } else {
                registerCubit.invalidInput();
              }
            },
          ),
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
          // The Register Route is popped from the navigation stack
          Navigator.pop(buildContext);
        },
      );
    });
  }
}
