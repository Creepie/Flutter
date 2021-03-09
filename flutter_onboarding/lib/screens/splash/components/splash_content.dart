

import 'package:flutter/cupertino.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }): super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(flex: 1),
        Text(
          "MYFLEXBOX",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(flex: 3),
        Image.asset(
          image,
          width: double.infinity,
        ),
        Spacer(flex: 1),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}