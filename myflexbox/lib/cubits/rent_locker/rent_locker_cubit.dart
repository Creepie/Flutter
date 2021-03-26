import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/models/google_places_data.dart';
import 'package:myflexbox/repos/rent_locker_repository.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class RentLockerCubit extends Cubit<RentLockerState> {
  final RentLockerRepository _rentLockerRepository;

  RentLockerCubit(this._rentLockerRepository)
      : super(FilterRentLockerState(
          boxSize: BoxSize.medium,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          location: MyLocationData(),
        ));

  Future<void> showMapScreen() async {
    if (state is FilterRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.location)));
    }
  }

  void changeBoxSize(BoxSize chosenBoxSize) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: chosenBoxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.location)));
    }
  }

  void changeDate(DateTime startDate, DateTime endDate) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: startDate,
          endDate: endDate,
          location: MyLocationData.clone(state.location)));
    }
  }

  void changeLocation(MyLocationData location) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: location));
    }
  }

  Future<void> getCurrentLocation() async {
    Location _locationTracker = Location();
    try {
      var location = await _locationTracker.getLocation();
      print("Lat and Long");
      final coordinates =
          new Coordinates(location.latitude, location.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      if (state is FilterRentLockerState) {
        emit(FilterRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: MyLocationData(
                lat: location.latitude,
                long: location.longitude,
                description: first.addressLine)));
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        emit(FilterRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: MyLocationData(
              lat: state.location.lat,
              long: state.location.long,
              description: state.location.description,
            )));
      }
    }
  }

  void showFilterScreen() {
    if (state is MapRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: (state as MapRentLockerState).boxSize));
    }
  }

  Future<void> fetchResults() async {
    //_rentLockerRepository.getLockers();
    _rentLockerRepository.getFilteredLockers("s", "2018-12-24T08%3A00%3A00%2B00%3A00", "2018-12-25T16%3A00%3A00%2B00%3A00", state.location.lat, state.location.long);
  }
}
