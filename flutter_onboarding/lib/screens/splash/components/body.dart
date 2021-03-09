import 'package:flutter/material.dart';
import 'package:flutter_onboarding/components/default_button.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/size_config.dart';

import '../components/splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to MYFLEXBOX, Screen 1",
      "image": "assets/images/onboarding_one_img.png"
    },
    {
      "text": "Welcome to MYFLEXBOX, Screen 2",
      "image": "assets/images/onboarding_two_img.png"
    },
    {
      "text": "Welcome to MYFLEXBOX, Screen 3",
      "image": "assets/images/onboarding_three_img.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: splashData.length,
                      itemBuilder: (context, index) => SplashContent(
                            image: splashData[index]["image"],
                            text: splashData[index]["text"],
                          ))),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            splashData.length, (index) => buildDot(index: index)),
                      ),
                      Spacer(flex: 1),
                      DefaultButton(
                        text: "Continue",
                        press: () {},
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8D),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}


