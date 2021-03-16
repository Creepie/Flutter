import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/form_data.dart';


abstract class RegisterState extends Equatable {
  final Email email;
  final Password password;
  final Username username;
  RegisterState({this.email, this.password, this.username});

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterInitial({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}

class RegisterLoadingState extends RegisterState {
  final Email email = Email();
  final Password password = Password();
  final Username username = Username();
}

class RegisterFailure extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterFailure({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}

class RegisterSuccess extends RegisterState {
  final Email email;
  final Password password;
  final Username username;
  RegisterSuccess({this.email, this.password, this.username});

  @override
  List<Object> get props => [email, password, username];
}