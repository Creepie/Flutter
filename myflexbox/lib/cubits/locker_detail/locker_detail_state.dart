import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/booking.dart';

abstract class LockerDetailState extends Equatable {
  final Booking booking;

  LockerDetailState(this.booking);

  //sets the value on which two states are compared. The UI is only rebuild, if
  //two stated are different.
  @override
  List<Object> get props => [];
}

class LockerDetailStateDefault extends LockerDetailState {
  LockerDetailStateDefault(Booking booking) : super(booking);
}

class LockerDetailStateShare extends LockerDetailState {
  LockerDetailStateShare(Booking booking) : super(booking);
}

class LockerDetailStateQR extends LockerDetailState {
  LockerDetailStateQR(Booking booking) : super(booking);
}
