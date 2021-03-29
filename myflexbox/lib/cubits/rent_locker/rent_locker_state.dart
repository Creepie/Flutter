import 'package:equatable/equatable.dart';
import 'package:myflexbox/repos/models/google_places_data.dart';
import 'package:myflexbox/repos/models/locker.dart';

enum BoxSize { medium, small, large, xlarge }

abstract class RentLockerState extends Equatable {
  final BoxSize boxSize;
  final DateTime startDate;
  final DateTime endDate;
  final MyLocationData chosenLocation;
  final MyLocationData myLocation;
  final List<Locker> lockerList;

  const RentLockerState({
    this.boxSize,
    this.startDate,
    this.endDate,
    this.chosenLocation,
    this.myLocation,
    this.lockerList,
  });

  @override
  List<Object> get props => [];
}

class LoadingRentLockerState extends RentLockerState {}

class FilterRentLockerState extends RentLockerState {
  @override
  List<Object> get props =>
      [boxSize, startDate, endDate, chosenLocation, myLocation];

  FilterRentLockerState({
    DateTime startDate,
    DateTime endDate,
    BoxSize boxSize,
    MyLocationData location,
    MyLocationData myLocation,
    List<Locker> lockerList,
  }) : super(
            boxSize: boxSize,
            startDate: startDate,
            endDate: endDate,
            chosenLocation: location,
            myLocation: myLocation,
            lockerList: lockerList);
}

class MapRentLockerState extends RentLockerState {
  @override
  List<Object> get props =>
      [boxSize, startDate, endDate, chosenLocation, myLocation];

  MapRentLockerState({
    DateTime startDate,
    DateTime endDate,
    BoxSize boxSize,
    MyLocationData location,
    MyLocationData myLocation,
    List<Locker> lockerList,
  }) : super(
            boxSize: boxSize,
            startDate: startDate,
            endDate: endDate,
            chosenLocation: location,
            myLocation: myLocation,
            lockerList: lockerList);
}

class SubmitRentLockerState extends RentLockerState {}
