import 'package:flutter/material.dart';
import 'package:flutter_profile/profile_menu.dart';
import 'package:flutter_profile/profile_pic.dart';

/// is a stateless widget, it doesn't change over time
/// menu stays always the same
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// SingleChildScrollView -> is a box im which a single widget can be scrolled
    return SingleChildScrollView(
      /// specifies offsets in terms of visual edges
      padding: EdgeInsets.symmetric(vertical: 20),
      /// a widget that displays its children in a vertical array
      child: Column(
        children: [
          /// is a widget class
          ProfilePic(),
          /// a box with a specified size
          SizedBox(height: 20),
          /// different menu points
          ProfileMenu(
            text: "Favoriten",
            icon: "assets/icons/Heart Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Passwort ändern",
            icon: "assets/icons/Lock.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Payment einrichten",
            icon: "assets/icons/Cash.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Payment verlauf",
            icon: "assets/icons/Bill Icon.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "OnBoarding neu starten",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

















