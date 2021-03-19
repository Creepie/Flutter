import 'package:bloc/bloc.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/repos/models/form_data.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthCubit authCubit;

  // The userRepository is passed in the constructor.
  // The initial state is emitted with empty password, email, and username
  // objects.
  RegisterCubit({this.authCubit})
      : super(RegisterInitial(
            email: Email(), password: Password(), username: Username()));

  //Register method, is called when the form is submitted by the user
  // The email, username and password are fetched from the current state.
  // The Register LoadingState is emitted
  // A method from the authCubit is called to register the user
  // If successful, the RegisterSuccess State is emitted
  // Otherwise the Failure is emitted with the according error set.
  Future<void> register() async {
    String emailText = state.email.text;
    String passwordText = state.password.text;
    String usernameText = state.username.text;
    emit(RegisterLoadingState());

    List error = await authCubit.registerWithEmail(
        emailText, passwordText, usernameText);
    if (error == null) {
      emit(RegisterSuccess(
          email: Email(error: null, text: emailText),
          password: Password(error: null, text: passwordText),
          username: Username(error: null, text: usernameText)));
    } else {
      ErrorType errorType = error[0];
      String errorText = error[1];
      if (errorType == ErrorType.EmailError) {
        emit(RegisterFailure(
            email: Email(error: errorText, text: emailText),
            password: Password(error: null, text: passwordText),
            username: Username(error: null, text: usernameText)));
      } else if (errorType == ErrorType.PasswordError) {
        emit(RegisterFailure(
            email: Email(error: null, text: emailText),
            password: Password(error: errorText, text: passwordText),
            username: Username(error: null, text: usernameText)));
      } else {
        emit(RegisterFailure(
            email: Email(error: null, text: emailText),
            password: Password(error: null, text: passwordText),
            username: Username(error: errorText, text: usernameText)));
      }
    }
  }

  //Is called when the email is changed.
  // Password, username, and email are cloned from the current state.
  // The text of the email object is updated with the parameter and the email
  // object is validated (sets the error in the object).
  // Then a new RegisterInitial state is emitted.
  void changedEmail(String emailText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    email.text = emailText;
    email.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

  //Is called when the password is changed.
  // Password, username, and email are cloned from the current state.
  // The text of the password object is updated with the parameter and the password
  // object is validated (sets the error in the object).
  // Then a new RegisterInitial state is emitted.
  void changedPassword(String passwordText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    password.text = passwordText;
    password.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

  //Is called when the username is changed.
  // Password, username, and email are cloned from the current state.
  // The text of the username object is updated with the parameter and the username
  // object is validated (sets the error in the object).
  // Then a new RegisterInitial state is emitted.
  void changedUsername(String usernameText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    username.text = usernameText;
    username.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

  // Is called, if the email, username or password objects have an error or are not filled.
  // If the text is empty, the error is set accordingly (otherwise, the error
  // remains the same)
  // A RegisterFailure State is emitted with the new email, username and password.
  void invalidInput() {
    Email email = Email.clone(state.email);
    if (email.text == null) {
      email.error = "Email is required";
    }
    Password password = Password.clone(state.password);
    if (password.text == null) {
      password.error = "Password is required";
    }
    Username username = Username.clone(state.username);
    if (username.text == null) {
      username.error = "Username is required";
    }
    emit(RegisterFailure(email: email, password: password, username: username));
  }
}
