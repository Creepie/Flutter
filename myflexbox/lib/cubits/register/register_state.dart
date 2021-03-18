import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/form_data.dart';


// Register States
// email, username and passwords are stored in the base class, so they are
// available in all states.
abstract class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final Username username;
  RegisterState({this.email, this.password, this.username});

  //sets the value on which two states are compared. The UI is only rebuild, if
  //two stated are different.
  @override
  List<Object> get props => [];
}

// Initial State, is emitted at the start, and also if
// the email, username or password is changed by the user
class RegisterInitial extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterInitial({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}

// Loading state, is emitted when the user is tried to register
// email, username and password objects are created, otherwise they would be null which
// would lead to an error in the form widget
class RegisterLoadingState extends RegisterState {
  final Email email = Email();
  final Password password = Password();
  final Username username = Username();
}

//State that gets emitted after an unsuccessful register try.
class RegisterFailure extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterFailure({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}

//State that gets emitted after an successful register try.
class RegisterSuccess extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterSuccess({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}