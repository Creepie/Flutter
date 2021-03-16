import 'package:flutter/material.dart';

class RegisterSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.check_circle_outline,
          color: Colors.black12,
          size: 130.0,
        ),
        SizedBox(
          height: 30,
          width: 20,
        ),
        SizedBox(
            width: 200,
            child: Text(
              "You registered successfully! \n Confirm your email to log in and get started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            )),
        SizedBox(
          height: 20,
          width: 20,
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Text(
            "login",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(buildContext);
          },
        ),
      ],
    );
  }
}
