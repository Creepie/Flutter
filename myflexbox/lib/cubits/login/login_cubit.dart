import 'package:bloc/bloc.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/repos/models/form_data.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepository;
  final AuthCubit authCubit;

  LoginCubit({this.userRepository, this.authCubit}) : super(LoginInitial(email: Email(), password: Password()));


  Future<void> login() async {
    String emailText = state.email.text;
    String passwordText = state.password.text;
    emit(LoadingLoginState());
    String token = await userRepository.authenticate(username: emailText, password: passwordText);
    if(token != null) {
      User user = await userRepository.getUser(token);
      authCubit.successfulLogin(user);
      return null;
    } else {
      emit(LoginFailure(
        email: Email(error: null, text: emailText),
        password: Password(error: "Passwort incorrect", text: passwordText),
      ));
    }
  }

  void changedEmail(String emailText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    email.text = emailText;
    email.validate();
    emit(LoginInitial(
        email: email,
        password: password));
  }

  void changedPassword(String passwordText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    password.text = passwordText;
    password.validate();
    emit(LoginInitial(
        email: email,
        password: password));
  }

  void invalidInput() {
    Email email = Email.clone(state.email);
    if(email.text == null) {
      email.error = "Email is required";
    }
    Password password = Password.clone(state.password);
    if(password.text == null) {
      password.error = "Password is required";
    }
    emit(LoginFailure(
      email: email,
      password: password,
    ));
  }
}