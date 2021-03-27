import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'abc',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bookCompartment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

final String baseUrl = "https://dev-myflxbx-rest.azurewebsites.net";
final String apiKey =
    "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9";

///GET without Params

Future<void> fetchData() async {
  var url = '$baseUrl/api/1/lockers';

  final response = await http.get(
    url,
    headers: {HttpHeaders.authorizationHeader: apiKey},
  );

  if (response.statusCode == 200) {
    List<Locker> list = json
        .decode(response.body)['lockers']
        .map((data) => Locker.fromJson(data))
        .toList()
        .cast<Locker>();

    var compartmentId = list[1].compartments[3].compartmentId;
    var lockerId = list[1].lockerId;
    print(response.toString());
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.toString());
  }
}

///GET with params

Future<List<Locker>> getFilteredLockers() async {
  final String startTime = "2021-04-01T08%3A00%3A00%2B00%3A00";
  final String endTime = "2021-04-05T16%3A00%3A00%2B00%3A00";

  var url = '$baseUrl/api/1/compartments?startTime=$startTime&endTime=$endTime';

  var response = await http.get(
    url,
    headers: {HttpHeaders.authorizationHeader: apiKey},
  );

  if (response.statusCode == 200) {
    List<Locker> list = json
        .decode(response.body)['lockers']
        .map((data) => Locker.fromJson(data))
        .toList()
        .cast<Locker>();

    var compartmentId = list[1].compartments[3].compartmentId;
    var lockerId = list[1].lockerId;
    return list;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.toString());
    return null;
  }
}

///POST in construction

Future<List<Locker>> bookCompartment() async {
  final String startTime = "2021-04-01T08:00:00+00:00";
  final String endTime = "2021-04-02T08:00:00+00:00";

  var url = '$baseUrl/api/1/booking';

  var booking = BookingRequest(21426, 21444, startTime, endTime, "User1", "Willhaben Iphone 8");

  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: apiKey
      },
      body: jsonEncode(booking));

  if (response.statusCode == 200) {
    Booking booking = Booking.fromJson(jsonDecode(response.body));
    print(response.body.toString());
    return null;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.toString());
    return null;
  }
}

class BookingRequest {
  final int lockerId;
  final int compartmentId;
  final String startTime;
  final String endTime;
  final String externalId;
  final String parcelNumber; //can be used for text message

  BookingRequest(this.lockerId, this.compartmentId, this.startTime,
      this.endTime, this.externalId, this.parcelNumber);

  Map<String, dynamic> toJson() => {
        'lockerId': lockerId,
        'compartmentId': compartmentId,
        'startTime': startTime,
        'endTime': endTime,
        'externalId': externalId,
        'parcelNumber': parcelNumber,
      };
}

class Booking {
  final int status;
  final int bookingId;
  final String parcelNumber;
  final String externalId;
  final int lockerId;
  final int compartmentId;
  final double compartmentLength;
  final double compartmentHeight;
  final double compartmentDepth;
  final String deliveryCode;
  final String collectingCode;
  final String state;
  final String startTimeSystem;
  final String startTime;
  final String endTime;
  final String endTimeSystem;
  final String message;

  Booking(
      {this.status,
      this.bookingId,
      this.parcelNumber,
      this.externalId,
      this.lockerId,
      this.compartmentId,
      this.compartmentLength,
      this.compartmentHeight,
      this.compartmentDepth,
      this.deliveryCode,
      this.collectingCode,
      this.state,
      this.startTimeSystem,
      this.startTime,
      this.endTime,
      this.endTimeSystem,
      this.message});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      status: json['status'] as int,
      bookingId: json['bookingId'] as int,
      parcelNumber: json['parcelNumber'] as String,
      externalId: json['externalId'] as String,
      lockerId: json['lockerId'] as int,
      compartmentId: json['compartmentId'] as int,
      compartmentLength: json['compartmentLength'] as double,
      compartmentHeight: json['compartmentHeight'] as double,
      compartmentDepth: json['compartmentDepth'] as double,
      deliveryCode: json['deliveryCode'] as String,
      collectingCode: json['collectingCode'] as String,
      state: json['state'] as String,
      startTimeSystem: json['startTimeSystem'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      endTimeSystem: json['endTimeSystem'] as String,
      message: json['message'] as String,
    );
  }
}

class Locker {
  final int lockerId;
  final String externalId;
  final String name;
  final String streetName;
  final String streetNumber;
  final String postcode;
  final String city;
  final String country;
  final String countryCode;
  final double longitude;
  final double latitude;
  final String state;
  final String access;
  final String manufacturer;
  final List<Compartment> compartments;

  Locker(
      {this.compartments,
      this.lockerId,
      this.externalId,
      this.name,
      this.streetName,
      this.streetNumber,
      this.postcode,
      this.city,
      this.country,
      this.countryCode,
      this.longitude,
      this.latitude,
      this.state,
      this.access,
      this.manufacturer});

  factory Locker.fromJson(Map<String, dynamic> json) {
    var list = json['compartments']
        .map((data) => Compartment.fromJson(data))
        .toList()
        .cast<Compartment>();
    return Locker(
      lockerId: json['lockerId'] as int,
      externalId: json['externalId'] as String,
      name: json['name'] as String,
      streetName: json['streetName'] as String,
      streetNumber: json['streetNumber'] as String,
      postcode: json['postcode'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      state: json['state'] as String,
      access: json['access'] as String,
      manufacturer: json['manufacturer'] as String,
      compartments: list as List<Compartment>,
    );
  }
}

class Compartment {
  final int compartmentId;
  final String number;
  final String size;
  final double length;
  final double height;
  final double depth;
  final String type;

  Compartment(
      {this.compartmentId,
      this.number,
      this.size,
      this.length,
      this.height,
      this.depth,
      this.type});

  factory Compartment.fromJson(Map<String, dynamic> json) {
    return Compartment(
      compartmentId: json['compartmentId'] as int,
      number: json['number'] as String,
      size: json['size'] as String,
      length: json['length'] as double,
      height: json['height'] as double,
      depth: json['depth'] as double,
      type: json['type'] as String,
    );
  }
}
