import 'package:bloc/bloc.dart';

import 'bottom_nav_state.dart';


class BottomNavCubit extends Cubit<BottomNavState> {

  BottomNavCubit() : super(CurrentLockersNavState());

  void changePage(int newPageIndex) async {
    switch (newPageIndex) {
      case 0:
        emit(CurrentLockersNavState());
        break;
      case 1:
        emit(AddLockerNavState());
        break;
      case 2:
        emit(NotificationNavState());
        break;
      case 3:
        emit(ProfileNavState());
        break;
    }
  }

  void changeDetected(int newPageIndex) {

  }
}