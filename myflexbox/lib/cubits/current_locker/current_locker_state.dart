import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/booking.dart';

abstract class CurrentLockerState extends Equatable {
  const CurrentLockerState();

  final filter = 1;

  /**
   * zum vergleichen der listen
   */
  @override
  List<Object> get props => [];
}

/**
 * if api call is not finished
 */
class CurrentLockerLoading extends CurrentLockerState {}

class CurrentLockerList extends CurrentLockerState {
  List<Booking> bookingList;

  CurrentLockerList({this.bookingList});

  @override
  List<Object> get props => [bookingList];
}

class CurrentLockerEmpty extends CurrentLockerState {

}
