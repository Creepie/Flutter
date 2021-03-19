import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_cubit.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_state.dart';


// Custom AppBar
// Depending on the state, the respective App Bar is returned
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          if(state is ProfileNavState) {
            return ProfileAppBar();
          } else {
            return DefaultAppBar();
          }
        }
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

//Default AppBar
class DefaultAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "My Flexbox",
          style: TextStyle(color: Colors.black),
        ));
  }
}

//Profile App Bar
class ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ));
  }
}