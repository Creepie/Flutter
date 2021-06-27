import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/booking.dart';

enum FilterStates {
  BOOKING_CREATED,
  COLLECTED,
  NOT_COLLECTED,
  CANCELED
}

abstract class CurrentLockerState extends Equatable {
  const CurrentLockerState(this.filter);

  final Map<FilterStates,bool> filter;

  /**
   * zum vergleichen der listen
   */
  @override
  List<Object> get props => [filter];
}

/**
 * if api call is not finished
 */
class CurrentLockerLoading extends CurrentLockerState {
  CurrentLockerLoading(Map<FilterStates,bool> filter) : super(filter);
}

class CurrentLockerList extends CurrentLockerState {
  List<Booking> bookingList;
  List<Booking> bookingListFiltered;

  CurrentLockerList({this.bookingList,this.bookingListFiltered,Map<FilterStates,bool> filter}) : super(filter);

  @override
  List<Object> get props => [bookingList,filter];
}

class CurrentLockerEmpty extends CurrentLockerState {
  CurrentLockerEmpty(Map<FilterStates,bool> filter) : super(filter);

}
