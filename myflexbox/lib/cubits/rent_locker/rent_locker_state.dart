import 'package:equatable/equatable.dart';

enum BoxSize{big, small, medium}


abstract class RentLockerState extends Equatable {
  @override
  List<Object> get props => [];
}


class LoadingRentLockerState extends RentLockerState {
}


class FilterRentLockerState extends RentLockerState {
  @override
  List<Object> get props => [boxSize];

  final BoxSize boxSize;

  FilterRentLockerState({this.boxSize});
}


class MapRentLockerState extends RentLockerState {
  @override
  List<Object> get props => [boxSize];

  final BoxSize boxSize;

  MapRentLockerState(this.boxSize);
}


class SubmitRentLockerState extends RentLockerState {}

