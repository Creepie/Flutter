import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:myflexbox/repos/models/google_places_data.dart';
import 'package:myflexbox/repos/models/locker.dart';
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
              lat: 47.804793263105125,
              long: 13.04687978865836,
              description: "Salzburg, Österreich",
            ),
            myLocation: MyLocationData(),
            lockerList: []));

  Future<void> switchScreen() async {
    if (state is FilterRentLockerState) {
      emit(
        MapRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: MyLocationData.clone(state.chosenLocation),
            myLocation: MyLocationData.clone(state.myLocation),
            lockerList: state.lockerList),
      );
      await Future.delayed(Duration(milliseconds: 900));
      updateCameraLocation();
    } else {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }
  }

  void changeBoxSize(BoxSize chosenBoxSize) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: chosenBoxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }

    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: chosenBoxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }
    fetchResults();
  }

  void changeDate(DateTime startDate, DateTime endDate) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: startDate,
          endDate: endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }
    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: startDate,
          endDate: endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }
    fetchResults();
  }

  void changeLocation(MyLocationData location) {
    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: location,
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }

    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: location,
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: state.lockerList));
    }
    fetchResults();
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
      var addressLine = first.addressLine.replaceAll("Austria", "Österreich");
      var myLocation = MyLocationData(
          lat: location.latitude,
          long: location.longitude,
          description: addressLine);
      if (state is FilterRentLockerState) {
        emit(FilterRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: myLocation,
            myLocation: myLocation,
            lockerList: state.lockerList));
      }

      if (state is MapRentLockerState) {
        emit(MapRentLockerState(
            boxSize: state.boxSize,
            startDate: state.startDate,
            endDate: state.endDate,
            location: myLocation,
            myLocation: myLocation,
            lockerList: state.lockerList));
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        if(state is FilterRentLockerState) {
          emit(FilterRentLockerState(
              boxSize: state.boxSize,
              startDate: state.startDate,
              endDate: state.endDate,
              location: MyLocationData(
                lat: state.chosenLocation.lat,
                long: state.chosenLocation.long,
                description: state.chosenLocation.description,
              ),
              myLocation: MyLocationData(),
              lockerList: state.lockerList));
        } else {
          emit(MapRentLockerState(
              boxSize: state.boxSize,
              startDate: state.startDate,
              endDate: state.endDate,
              location: MyLocationData(
                lat: state.chosenLocation.lat,
                long: state.chosenLocation.long,
                description: state.chosenLocation.description,
              ),
              myLocation: MyLocationData(),
              lockerList: state.lockerList));
        }

      }
    }
    fetchResults();
  }

  Future<void> fetchResults() async {
    var lockerList = await _rentLockerRepository.getFilteredLockers(
        "s",
        "2021-04-24T08%3A00%3A00%2B00%3A00",
        "2021-04-25T16%3A00%3A00%2B00%3A00",
        state.chosenLocation.lat,
        state.chosenLocation.long);

    if (state is FilterRentLockerState) {
      emit(FilterRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: lockerList));
    }

    if (state is MapRentLockerState) {
      emit(MapRentLockerState(
          boxSize: state.boxSize,
          startDate: state.startDate,
          endDate: state.endDate,
          location: MyLocationData.clone(state.chosenLocation),
          myLocation: MyLocationData.clone(state.myLocation),
          lockerList: lockerList));
      updateCameraLocation();
    }
  }

  Future<void> updateCameraLocation() async {
    if (state.lockerList.length == 0 || mapsController == null) {
      return;
    }

    String ld = state.chosenLocation.description;
    int countOfComma = 0;
    for (int i = ld.indexOf(",");
        i >= 0;
        i = state.chosenLocation.description.indexOf(",", i + 1)) {
      countOfComma++;
    }

    if (countOfComma <= 1) {
      mapsController.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              target:
                  LatLng(state.chosenLocation.lat, state.chosenLocation.long),
              tilt: 0,
              zoom: 12.4746)));
      return;
    }

    Locker nearestLocker = state.lockerList[0];
    LatLng source = LatLng(state.chosenLocation.lat, state.chosenLocation.long);
    LatLng destination =
        LatLng(nearestLocker.latitude, nearestLocker.longitude);
    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate) async {
    mapsController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapsController.getVisibleRegion();
    LatLngBounds l2 = await mapsController.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate);
    }
  }
}
