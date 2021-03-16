import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePic extends StatelessWidget {

  const ProfilePic({
    Key key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// box with specified size
    return  SizedBox(
        height: 115,
        width: 115,
        /// a widget that positions its children relative to the edges of its box
        /// useful if you want to overlap several children in a simple way
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: [
            /// circle that represents a user
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/Profile Image.png"),),
            /// controls where a child of a stack is positioned
            Positioned(
                right: -16,
                bottom: 0,
                /// box with specified size
                child: SizedBox(
                  height: 46,
                  width: 46,
                  /// text label material widget that performs an action when the button is tapped
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.white),
                    ),
                    color: Color(0xFFF5F6F9),
                    onPressed: (){},
                    child: SvgPicture.asset("assets/icons/Camera Icon.svg"), //?import 'package:flutter_svg/flutter_svg.dart';


                  ),
                ))
          ],
        )
    );
  }
}
