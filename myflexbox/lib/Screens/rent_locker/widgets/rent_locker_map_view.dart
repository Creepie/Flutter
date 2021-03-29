import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_cubit.dart';
import 'package:myflexbox/cubits/rent_locker/rent_locker_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RentLockerMapView extends StatelessWidget {
  final markers = HashSet<Marker>();
  final circles = HashSet<Circle>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentLockerCubit, RentLockerState>(
      builder: (context, state) {
      markers.clear();
      circles.clear();
      if (state.myLocation != null) {
        var newCircle = Circle(
            circleId: CircleId("car"),
            zIndex: 1,
            radius: 30,
            strokeColor: Colors.blue,
            center: LatLng(state.myLocation.lat, state.myLocation.long),
            fillColor: Colors.blue.withAlpha(70));
        circles.add(newCircle);
      }

      //for loop where for each locker, a marker is displayed

      return Expanded(
        child: GestureDetector(
          child: GoogleMap(
            //normal, satellite, ...
            mapType: MapType.normal,
            //first Camera Position
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(state.chosenLocation.lat, state.chosenLocation.long),
              zoom: 13.4746,
            ),
            //add all markers
            //markers: _markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller) {
              var rentLockerCubit = context.read<RentLockerCubit>();
              rentLockerCubit.mapsController = controller;
            },
          ),
        ),
      );
    });
  }
}
