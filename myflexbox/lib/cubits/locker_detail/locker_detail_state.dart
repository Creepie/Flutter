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

class LockerDetailStateLoading extends LockerDetailState {
  LockerDetailStateLoading(Booking booking) : super(booking);
}
