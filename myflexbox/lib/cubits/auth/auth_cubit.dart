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
        var user = await userRepository.getUserFromDB(firebaseUser.uid);
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
        var firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
        //throw Exception();
        if(!firebaseUser.emailVerified) {
          return [ErrorType.EmailError, "Email nicht verifiziert"];
        } else {
          var user = await userRepository.getUserFromDB(firebaseUser.uid);
          emit(AuthAuthenticated(user));
        }

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

      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      user.user.sendEmailVerification();
      var token = user.user.getIdToken(true);
      List<String> testList = [];
      testList.add("User1");
      testList.add("User2");
      var success = await userRepository.addUserToDB(DBUser(email,username,"123",user.user.uid, testList));
      if(success){
        return null;
      } else {
        return [ErrorType.EmailError, "Es gab ein Problem mit der Datenbank"];
      }
    } catch(e) {
      print(e.toString());
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
