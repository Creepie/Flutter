import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_cubit.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RentLockerMapView extends StatefulWidget {
  @override
  _RentLockerMapViewState createState() => _RentLockerMapViewState();
}

class _RentLockerMapViewState extends State<RentLockerMapView> {
  final markers = HashSet<Marker>();
  final circles = HashSet<Circle>();
  BitmapDescriptor flexboxMarker;
  BitmapDescriptor myLocationMarker;

  @override
  void initState() {
    getMarker();
  }

  void getMarker() async {
    flexboxMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/flexbox_marker.png');
    myLocationMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/mylocation_marker.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentLockerCubit, RentLockerState>(
        builder: (context, state) {
      markers.clear();
      circles.clear();
      //set myLocation marker
      if (state.myLocation != null) {
        var newMarker = Marker(
            markerId: MarkerId("myPosition"),
            position: LatLng(state.myLocation.lat, state.myLocation.long),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: myLocationMarker != null
                ? myLocationMarker
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue));
        markers.add(newMarker);

        //check if its a city or a full address
        String ld = state.chosenLocation.description;
        int countOfComma = 0;
        for (int i = ld.indexOf(",");
            i >= 0;
            i = state.chosenLocation.description.indexOf(",", i + 1)) {
          countOfComma++;
        }
        //if its not a city, display a marker
        if (countOfComma >= 2 &&
            state.myLocation.description != state.chosenLocation.description) {
          var newMarker = Marker(
              markerId: MarkerId("chosenPosition"),
              position:
                  LatLng(state.chosenLocation.lat, state.chosenLocation.long),
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.5, 0.5),
              icon: BitmapDescriptor.defaultMarker);
          markers.add(newMarker);
        }
      }

      //display markers for the
      for (var i = 0; i < state.lockerList.length; i++) {
        var locker = state.lockerList[i];
        var newMarker = Marker(
            markerId: MarkerId("locker $i"),
            position: LatLng(locker.latitude, locker.longitude),
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: flexboxMarker != null
                ? flexboxMarker
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue));
        markers.add(newMarker);
      }

      return Expanded(
        child: GoogleMap(
          //normal, satellite, ...
          mapType: MapType.normal,
          //first Camera Position
          initialCameraPosition: CameraPosition(
            target: LatLng(state.chosenLocation.lat, state.chosenLocation.long),
            zoom: 10.4746,
          ),
          //add all markers
          //markers: _markers,
          circles: circles,
          markers: markers,
          rotateGesturesEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            var rentLockerCubit = context.read<RentLockerCubit>();
            rentLockerCubit.mapsController = controller;
          },
        ),
      );
    });
  }
}
