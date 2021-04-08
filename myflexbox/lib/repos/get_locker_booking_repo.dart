import 'dart:convert';
import 'dart:io';
import 'package:myflexbox/repos/models/booking.dart';
import 'package:http/http.dart' as http;

class GetLockerBooking{

  ///the [apiKey] is needed in each api call and is stored in the auth header
  final String apiKey = "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9";

  ///the [baseUrl] is needed in each api call for building the url endpoint
  final String baseUrl = "https://dev-myflxbx-rest.azurewebsites.net";


  ///this method Retrieves a List of [Booking] where the externalId (Firebase Uid) matches
  Future<List<Booking>> getBookings(String externalId) async {
    var url = '$baseUrl/api/1/bookings?externalId=${externalId}';
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      List<Booking> list = json
          .decode(response.body)['bookings']
          .map((data) => Booking.fromJson(data))
          .toList().cast<Booking>();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }

  ///this method Retrieves one [Booking] with a given bookingId
  Future<Booking> getBooking(String bookingId) async{
    var url = '$baseUrl/api/1/booking?bookingId=${bookingId}';
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      return null;
    }
  }


}