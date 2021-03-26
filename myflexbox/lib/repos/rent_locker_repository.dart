import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'models/locker.dart';

class RentLockerRepository {
  final String apiKey = "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9";

  Future<List<Locker>> getLockers() async {
    var url = Uri.https(
        'dev-myflxbx-rest.azurewebsites.net', '/api/1/lockers', {'q': '{https}'});
    final response = await http.get(url, headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      List<Locker> list = json
          .decode(response.body)['lockers']
          .map((data) => Locker.fromJson(data))
          .toList().cast<Locker>();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

  Future<List<Locker>> getFilteredLockers(int size, String startTime, String endTime, double lat, double long) async {
    var url = Uri.https(
        'dev-myflxbx-rest.azurewebsites.net', '/api/1/compartments?size=$size&startTime=$startTime&endTime=$endTime&limit=10&latitude=$lat&longitude=$long', {'q': '{https}'});
    final response = await http.get(url, headers: {HttpHeaders.authorizationHeader: apiKey},);

    if (response.statusCode == 200) {
      List<Locker> list = json
          .decode(response.body)['lockers']
          .map((data) => Locker.fromJson(data))
          .toList().cast<Locker>();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return null;
    }
  }

}