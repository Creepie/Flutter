import 'package:bloc/bloc.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;

  AuthCubit(this.userRepository) : super(AuthUninitialized());

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

  Future<void> successfulLogin(User user) async {
    emit(AuthAuthenticated(user));
  }
}
