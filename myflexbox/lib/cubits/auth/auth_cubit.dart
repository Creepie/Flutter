import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myflexbox/repos/models/form_data.dart';
import 'package:myflexbox/repos/models/user.dart';
import 'package:myflexbox/repos/user_repo.dart';
import 'auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Handles the authentication of the user
// Is available in all widgets of the app
class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;
 // final FirebaseAuth _firebaseAuth;

  // UserRepository is passed in the constructor
  AuthCubit(this.userRepository) : super(AuthUninitialized());

  // Checks if the user is already logged in or not.
  // Emits the AuthLoading State at the start.
  // Emits a different state depending on the result.
  Future<void> authenticate() async {
      await Firebase.initializeApp();
      emit(AuthLoading());
      //get user with FirebaseAuth.instance.currentUser
      var firebaseUser = await FirebaseAuth.instance.currentUser;

      if(firebaseUser != null) {
        //get token with fireBaseUser.getIdToken(refresh: true)
        //get user name from firebase
        UserCredential credential = null;
        var idToken = await firebaseUser.getIdToken(true);
        DBUser user = DBUser("email", "name", idToken, credential);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
  }

  // Tries login with email and password
  // If successful:
  // get the token, get the user name, create user object,
  // emit AuthAuthenticated
  // If unsuccessful:
  // Catches Exceptions thrown by firebase and returns error messages
  Future<List> loginWithEmail(String email, String password) async {
      try {
        await Future.delayed(Duration(seconds: 1));
        var firebaseUserCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        var userToken = await firebaseUserCredential.user.getIdToken(true);
        //throw Exception();
        if(!firebaseUserCredential.user.emailVerified) {
          return [ErrorType.EmailError, "Email nicht verifiziert"];
        } else {
          emit(AuthAuthenticated(DBUser(email, "", userToken, firebaseUserCredential)));
        }

        /*
        if(fireBaseUser != null) {
          //get token with token = fireBaseUser.getIdToken(refresh: true)
          //get username from firebase
          User user = User("email", "name", "token", "firebaseUser");
          emit(AuthAuthenticated(user));
          return null;
        }
         */
      } catch(e) {
        return [ErrorType.EmailError, "Es gab ein Problem beim Login"]; //delete that
        switch(e.code) {
          case "ERROR_WRONG_PASSWORD":
            return [ErrorType.PasswordError,"Passwort ist falsch"];
          default:
            print("here");
            return [ErrorType.EmailError, "Es gab ein Problem beim Login"];
        }
      }
  }

  // Tries registration with email and password
  // If successful:
  // get the token, create user in the database,
  // return null
  // If unsuccessful:
  // Catches Exceptions thrown by firebase and returns error messages
  Future<List> registerWithEmail(String email, String password, String username) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      //Create user with firebaseUser = auth.createUserWithEmailAndPassword()
      //Create a user in the users table in firebase
      //throw Exception();
      //repo.createUser();
      //user wieder ausloggen
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      user.user.sendEmailVerification();
      // Todo -> create DBUser and save to database
      return null;
    } catch(e) {
      return [ErrorType.EmailError, "Es gab ein Problem beim Login"]; //delete
      switch(e.code) {
        case "":
          return [ErrorType.EmailError,"Email ist nicht zugelassen"];
        default:
          return [ErrorType.EmailError, "Es gab ein Problem beim registrieren"];
      }
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    //emit(AuthAuthenticated(user))
  }

  Future<void> logout() async {
    print("hello");
    await FirebaseAuth.instance.signOut();
    emit(AuthUnauthenticated());
}

}
