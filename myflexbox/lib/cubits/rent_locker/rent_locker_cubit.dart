import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/models/google_places_data.dart';
import 'package:myflexbox/repos/rent_locker_repository.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class RentLockerCubit extends Cubit<RentLockerState> {
  final RentLockerRepository _rentLockerRepository;
  GoogleMapController mapsController;

  RentLockerCubit(this._rentLockerRepository)
      : super(FilterRentLockerState(
          boxSize: BoxSize.medium,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          location: MyLocationData(
            lat: 48.29272188372836,
            long: 14.294605402333424,
            description: null,
          ),
        ));

  Future<void> switchScreen() async {
    if (state is FilterRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation)));
    } else {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation)));
    }
  }

  void changeBoxSize(BoxSize chosenBoxSize) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: chosenBoxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation)));
    }

    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: chosenBoxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation)));
    }
  }

  void changeDate(DateTime startDate, DateTime endDate) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: startDate,
          endDate: endDate,
          location: MyLocationData.clone(state.chosenLocation)));
    }
    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: startDate,
          endDate: endDate,
          location: MyLocationData.clone(state.chosenLocation)));
    }
  }

  void changeLocation(MyLocationData location) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: location,
          myLocation: MyLocationData.clone(state.myLocation)));
    }

    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: location,
          myLocation: MyLocationData.clone(state.myLocation)));
      if (mapsController != null) {
        mapsController.animateCamera(CameraUpdate.newCameraPosition(
            new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(location.lat, location.long),
                tilt: 0,
                zoom: 13.4746)));
      }
    }
  }

  Future<void> getCurrentLocation() async {
    Location _locationTracker = Location();
    try {
      var location = await _locationTracker.getLocation();
      final coordinates =
          new Coordinates(location.latitude, location.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      var myLocation = MyLocationData(
          lat: location.latitude,
          long: location.longitude,
          description: first.addressLine);
      if (state is FilterRentLockerState) {
        emit(FilterRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: myLocation,
            myLocation: myLocation));
      }

      if (state is MapRentLockerState) {
        emit(MapRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: myLocation,
            myLocation: myLocation));
        if (mapsController != null) {
          mapsController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(myLocation.lat, myLocation.long),
                  tilt: 0,
                  zoom: 13.4746)));
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        emit(FilterRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: MyLocationData(
              lat: state.chosenLocation.lat,
              long: state.chosenLocation.long,
              description: state.chosenLocation.description,
            )));
      }
    }
  }

  Future<void> fetchResults() async {
    //_rentLockerRepository.getLockers();
    _rentLockerRepository.getFilteredLockers(
        "s",
        "2018-12-24T08%3A00%3A00%2B00%3A00",
        "2018-12-25T16%3A00%3A00%2B00%3A00",
        state.chosenLocation.lat,
        state.chosenLocation.long);
  }
}
