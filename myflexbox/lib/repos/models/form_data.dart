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