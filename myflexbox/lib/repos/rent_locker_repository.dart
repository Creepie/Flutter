import 'dart:convert';
import 'dart:io';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:myflexbox/repos/models/booking_request.dart';

import 'models/locker.dart';
import 'package:http/http.dart' as http;

class RentLockerRepository {

  final String apiKey = "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9";
  final String baseUrl = "https://dev-myflxbx-rest.azurewebsites.net";

  Future<List<Locker>> getLockers() async {
    var url = '$baseUrl/api/1/lockers';
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      List<Locker> list = json
          .decode(response.body)['lockers']
          .map((data) => Locker.fromJson(data))
          .toList().cast<Locker>();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }

  Future<List<Locker>> getFilteredLockers(String size, String startTime, String endTime, double lat, double long) async {
    var url = '$baseUrl/api/1/compartments?site=$size&startTime=$startTime&endTime=$endTime&limit=10&latitude=$lat&longitude=$long';
    var response = await http.get(Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      List<Locker> list = json
          .decode(response.body)['lockers']
          .map((data) => Locker.fromJson(data))
          .toList().cast<Locker>();
      return list;
    } else {
      print(response.statusCode.toString());
      print(response.reasonPhrase);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }


  Future<Booking> bookLocker(BookingRequest request) async {

    //only for testing
    //final String startTime = "2021-04-01T08:00:00+00:00";
    //final String endTime = "2021-04-02T08:00:00+00:00";
    //var booking = BookingRequest(21426, 21444, startTime, endTime, "User1", "Willhaben Iphone 8");

    var url = '$baseUrl/api/1/booking';

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: apiKey
        },
        body: jsonEncode(request));

    if (response.statusCode == 200) {
      // If the server return a 200 create a booking object and return it
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      print(response.toString());
      return null;
    }
  }
}