import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
        onPressed: fetchData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> _incrementCounter() async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  var url =
      Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    var itemCount = jsonResponse['totalItems'];
    print('Number of books about http: $itemCount.');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> fetchData() async {
  var url = Uri.https(
      'dev-myflxbx-rest.azurewebsites.net', '/api/1/lockers', {'q': '{https}'});
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader:
          "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9"
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var test =  Locker.fromJson(jsonDecode(response.body));
    print(response.toString());
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
  final responseJson = jsonDecode(response.body);

  var lockers = Locker.fromJson(responseJson);



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

  Locker({
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

  factory Locker.fromJson(Map<dynamic, dynamic> json){
    return Locker(
      lockerId: json['lockerId'],
      externalId: json['externalId'],
      name: json['name'],
      streetName: json['streetName'],
      streetNumber: json['streetNumber'],
      postcode: json['postcode'],
      city: json['city'],
      country: json['country'],
      countryCode: json['countryCode'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      state: json['state'],
      access: json['access'],
      manufacturer: json['manufacturer'],
    );
  }

}