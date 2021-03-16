import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:myflexbox/Screens/profile/profile_page.dart';
import 'package:myflexbox/Screens/rent_locker/rent_locker_page.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_cubit.dart';
import 'package:myflexbox/cubits/bottom_nav/bottom_nav_state.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_cubit.dart';
import 'package:myflexbox/repos/rent_locker_repository.dart';

import 'current_lockers/current_locker_page.dart';
import 'notification/notification_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool stoppedAnimating = true;

  List<Widget> getPages(BuildContext context) {
    return [
      CurrentLockersPage(),
      RentLockerPage(),
      NotificationPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        appBar: buildAppBar(),
        bottomNavigationBar: buildNavigationBar(),
        body: BlocConsumer<BottomNavCubit, BottomNavState>(
            listener: (context, state) {
              stoppedAnimating = false;
              _pageController.animateToPage(state.pageIndex,
              duration: Duration(milliseconds: 500), curve: Curves.easeOut).then((_)  {
                stoppedAnimating = true;
              });
            },
            builder: (context, state) {
            return MultiBlocProvider(
                providers: [
                  BlocProvider<RentLockerCubit>(
                    create: (context) => RentLockerCubit(RentLockerRepository()),
                  ),
                ],
              child: PageView(
                onPageChanged: (index) {
                  if(stoppedAnimating){
                    final bottomNavCubit = context.read<BottomNavCubit>();
                    bottomNavCubit.changePage(index);
                  }
                },
                controller: _pageController,
                children: getPages(buildContext),
              ));
        }),
    );
  }

  Widget buildAppBar() {
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

  Widget buildNavigationBar() {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
      return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
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
                    text: 'Lockers',
                  ),
                  GButton(
                    icon: Icons.add,
                    text: 'Add',
                  ),
                  GButton(
                    icon: Icons.notifications,
                    text: 'Notify',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: state.pageIndex,
                onTabChange: (index) {
                  final bottomNavCubit = context.read<BottomNavCubit>();
                  bottomNavCubit.changePage(index);
                }),
          ),
        ),
      );
    });
  }
}
