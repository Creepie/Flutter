import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/Screens/profile/widgets/profile_menu.dart';
import 'package:myflexbox/Screens/profile/widgets/profile_pic.dart';
import 'package:myflexbox/cubits/auth/auth_cubit.dart';
import 'package:myflexbox/cubits/auth/auth_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myflexbox/config/app_router.dart';

/// is a stateless widget, it doesn't change over time
/// menu stays always the same
class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// SingleChildScrollView -> is a box im which a single widget can be scrolled
    return SingleChildScrollView(
      /// specifies offsets in terms of visual edges
      padding: EdgeInsets.symmetric(vertical: 20),

      /// a widget that displays its children in a vertical array
      child: Column(
        children: [
          /*
          BlocBuilder<AuthCubit, AuthState>(
            builder: (cubitContext, state) {
              return Text(state is AuthAuthenticated ? state.user.email : "");
            },
          ),

           */

          /// is a widget class
          ProfilePic(),

          /// a box with a specified size
          SizedBox(height: 20),

          /// different menu points
          ProfileMenu(
            text: "Favoriten",
            icon: "assets/icons/Heart_Icon.svg",
            press: () async => {
              if (await Permission.contacts.request().isGranted)
                {Navigator.pushNamed(context, AppRouter.ContactViewRoute)}
            },
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
            icon: "assets/icons/Bill_Icon.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "OnBoarding neu starten",
            icon: "assets/icons/Question_mark.svg",
            press: () {},
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (cubitContext, state) {
              return ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log_out.svg",
                press: () async {
                  var authCubit = cubitContext.read<AuthCubit>();
                  await authCubit.logout();
                  var arguments = {
                    "authCubit": authCubit,
                    "userRepository": authCubit.userRepository
                  };
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRouter.LoginViewRoute, (route) => false,
                      arguments: arguments);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
