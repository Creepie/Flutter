enum ErrorType{PasswordError, EmailError}

//Email FormData class
//Stores the email text and the error.
//Has a function for validation which sets the error, when its called
class Email {
  String text;
  String error;

  Email({this.text, this.error});

  Email.clone(Email email): this(text: email.text, error: email.error);

  void validate() {
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text);
      if(!emailValid) {
        error = "Gültige Email eingeben";
      } else {
        error = null;
      }
  }
}

//Password FormData class
//Stores the password text and the error.
//Has a function for validation which sets the error, when its called
class Password {
  String text;
  String error;

  Password({this.text, this.error});

  Password.clone(Password password): this(text: password.text, error: password.error);

  void validate() {
    if(text.length <= 4) {
      error = "Muss länger als 4 Zeichen sein";
    } else {
      error = null;
    }
  }
}

//Username FormData class
//Stores the username text and the error.
//Has a function for validation which sets the error, when its called
class Username {
  String text;
  String error;

  Username({this.text, this.error});

  Username.clone(Username username): this(text: username.text, error: username.error);

  void validate() {
    if(text.length <= 3) {
      error = "Muss länger als 3 Zeichen sein";
    } else {
      error = null;
    }
  }
}