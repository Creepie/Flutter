import 'package:equatable/equatable.dart';

abstract class BottomNavState extends Equatable {
  final int pageIndex = 0;
  @override
  List<Object> get props => [];
}

class CurrentLockersNavState extends BottomNavState {
  final int pageIndex = 0;

  CurrentLockersNavState();
}

class AddLockerNavState extends BottomNavState {
  final int pageIndex = 1;

  AddLockerNavState();
}

class NotificationNavState extends BottomNavState {
  final int pageIndex = 2;

  NotificationNavState();
}

class ProfileNavState extends BottomNavState {
  final int pageIndex = 3;

  ProfileNavState();
}

