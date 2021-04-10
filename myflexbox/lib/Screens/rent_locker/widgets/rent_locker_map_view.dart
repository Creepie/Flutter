import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myflexbox/config/size_config.dart';
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

  //Function for creating the Bitmaps for the markers
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

      //Set my Location marker
      if (state.myLocation.description != null) {
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

        //Set chosen Location Marker
        if (state.chosenLocation.isExactLocation &&
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

      //Display markers for the Lockers
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
        child: Stack(
          children: [
            GoogleMap(
              //normal, satellite, ...
              mapType: MapType.normal,
              //first Camera Position
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(state.chosenLocation.lat, state.chosenLocation.long),
                zoom: 10.4746,
              ),
              //add all markers
              //markers: _markers,
              circles: circles,
              markers: markers,
              rotateGesturesEnabled: false,
              onMapCreated: (GoogleMapController controller) async {
                var rentLockerCubit = context.read<RentLockerCubit>();
                rentLockerCubit.mapsController = controller;
                await Future.delayed(Duration(milliseconds: 700));
                rentLockerCubit.updateCameraLocation();
              },
            ),
            state is MapRentLockerLoadingState
                ? MapLoadingIndicator()
                : Container(),
          ],
        ),
      );
    });
  }
}

class MapLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("loading");
    return Positioned(
      top: 20,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[800],
          ),
          height: 30,
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Searching",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
                width: 5,
              ),
              SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
