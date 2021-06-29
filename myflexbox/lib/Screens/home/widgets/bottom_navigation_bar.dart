import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_cubit.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_state.dart';

//Bottom Navigation Bar
class BottomGoogleNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.03))
            ]),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
                child: GNav(
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 600),
                    tabBackgroundColor: Colors.grey[800],
                    tabs: [
                      GButton(
                        icon: Icons.markunread_mailbox,
                        text: 'Verlauf',
                      ),
                      GButton(
                        icon: Icons.add,
                        text: 'Hinzufügen',
                      ),
                      GButton(
                        icon: Icons.notifications,
                        text: 'Neuigkeiten',
                      ),
                      GButton(
                        icon: Icons.person,
                        text: 'Profil',
                      ),
                    ],
                    selectedIndex: state.pageIndex,
                    onTabChange: (index) {
                      // the changePage method of the bottomNavCubit is called, when
                      // a user tabs on an item of the nav bar.
                      final bottomNavCubit = context.read<BottomNavCubit>();
                      bottomNavCubit.changePage(index);
                    }),
              ),
            ),
          );
        });
  }

}