import 'package:bloc/bloc.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'auth_state.dart';

// Handles the authentication of the user
// Is available in all widgets of the app
class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;

  // UserRepository is passed in the constructor
  AuthCubit(this.userRepository) : super(AuthUninitialized());

  // Checks if the user is already logged in or not.
  // Emits the AuthLoading State at the start.
  // Emits a different state depending on the result.
  Future<void> authenticate() async {
      emit(AuthLoading());
      final token = await userRepository.hasToken();
      if(token != null) {
        User user = await userRepository.getUser(token);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
  }

  // Method that is called by the LoginCubit, if the login was
  // successful. THe AuthAuthenticated state is emitted.
  Future<void> successfulLogin(User user) async {
    emit(AuthAuthenticated(user));
  }
}
