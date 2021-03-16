import 'package:bloc/bloc.dart';
import 'package:myflexbox/repos/models/form_data.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository userRepository;

  RegisterCubit({this.userRepository})
      : super(RegisterInitial(
            email: Email(), password: Password(), username: Username()));

  Future<void> register() async {
    String emailText = state.email.text;
    String passwordText = state.password.text;
    String usernameText = state.username.text;
    emit(RegisterLoadingState());
    String error = await userRepository.register(username: usernameText, password: passwordText);
    if (error == null) {
      emit(RegisterSuccess(
          email: Email(error: null, text: emailText),
          password: Password(error: null, text: passwordText),
          username: Username(error: null, text: usernameText)));
    } else {
      emit(RegisterFailure(
        email: Email(error: "Email bereits in Verwendung", text: emailText),
        password: Password(error: null, text: passwordText),
        username: Username(error: null, text: usernameText),
      ));
    }
  }

  void changedEmail(String emailText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    email.text = emailText;
    email.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

  void changedPassword(String passwordText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    password.text = passwordText;
    password.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

  void changedUsername(String usernameText) {
    Password password = Password.clone(state.password);
    Email email = Email.clone(state.email);
    Username username = Username.clone(state.username);
    username.text = usernameText;
    username.validate();
    emit(RegisterInitial(email: email, password: password, username: username));
  }

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
