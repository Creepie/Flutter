import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/form_data.dart';

abstract class LoginState extends Equatable {
  final Email email;
  final Password password;
  LoginState({this.email, this.password});

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final Email email;
  final Password password;
  LoginInitial({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LoadingLoginState extends LoginState {
  final Email email = Email();
  final Password password = Password();
}

class LoginFailure extends LoginState {
  final Email email;
  final Password password;
  LoginFailure({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
