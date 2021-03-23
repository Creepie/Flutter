import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Map Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //this variables is to get the current location of the user
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  //in the _markers all markers get saved
  Set<Marker> _markers = HashSet<Marker>();
  //this circle is to highlight the current location of the user on the map
  Circle circle;
  //this controller is to have access to the googleMap if location is chanced
  GoogleMapController _controller;
  //this counter is to have unique marker ids
  int markerIdCounter = 0;

  ///init the screen with 2 Marker
  @override
  void initState() {
    addMarker(LatLng(48.213589, 14.201941));
    addMarker(LatLng(48.214490, 14.201622));
    super.initState();
  }

  ///init where the cam should start and the zoom factor
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  ///get a custom marker from the assets folder for current location of user
  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  ///this method updates the my location marker with new data
  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    ///save the current lat / long data
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      ///remove the old home marker before set a new one
      _markers.removeWhere((element) => element.markerId.value == "home" );
      ///update my location marker
        _markers.add(Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: newLocalData.heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData)));
      ///update the circle
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  ///this method adds marker to the map (for example locker)
  ///https://medium.com/@zeh.henrique92/google-maps-flutter-marker-circle-and-polygon-c71f4ea64498
  void addMarker(LatLng point){
    final String markerId = 'marker_id_$markerIdCounter';
    markerIdCounter++;
    
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
      )
    );
  }

  ///this method try to get the currentLocation of the user
  void getCurrentLocation() async {
    try {

      //get image of the marker (red car)
      Uint8List imageData = await getMarker();
      //save the current location
      var location = await _locationTracker.getLocation();
      //update the marker of my location
      updateMarkerAndCircle(location, imageData);
      //cancel the subscription is already active
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      //listen if location got changed > if yes update the map
      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      //if the user don't granted the permission
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }


  /// if app comes into background cancel the location tracking
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        //normal, satellite, ...
        mapType: MapType.normal,
        //first Camera Position
        initialCameraPosition: initialLocation,
        //add all markers
        markers: _markers,
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          //add a controller for accessing the map with buttons, ...)
          _controller = controller;
        },

      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            //get and update the current location of the user
            getCurrentLocation();
          }),
    );
  }
}
