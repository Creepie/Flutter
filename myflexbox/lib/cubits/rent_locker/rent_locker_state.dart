import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/google_places_data.dart';

enum BoxSize{medium, small, large, xlarge}


abstract class RentLockerState extends Equatable {
  final BoxSize boxSize;
  final DateTime startDate;
  final DateTime endDate;
  final MyLocationData location;

  const RentLockerState({this.boxSize, this.startDate, this.endDate, this.location});

  @override
  List<Object> get props => [];
}


class LoadingRentLockerState extends RentLockerState {
}


class FilterRentLockerState extends RentLockerState {
  @override
  List<Object> get props => [boxSize, startDate, endDate, location];

  FilterRentLockerState({
    DateTime startDate,
    DateTime endDate,
    BoxSize boxSize,
    MyLocationData location
  }): super(
    boxSize: boxSize,
    startDate: startDate,
    endDate: endDate,
    location: location,
  );
}


class MapRentLockerState extends RentLockerState {

  @override
  List<Object> get props => [boxSize, startDate, endDate, location];

  MapRentLockerState({
    DateTime startDate,
    DateTime endDate,
    BoxSize boxSize,
    MyLocationData location
  }): super(
    boxSize: boxSize,
    startDate: startDate,
    endDate: endDate,
    location: location,
  );
}


class SubmitRentLockerState extends RentLockerState {}

