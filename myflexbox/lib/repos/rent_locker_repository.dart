import 'dart:convert';
import 'dart:io';
import 'models/locker.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Locker>> getFilteredLockers(String size, String startTime, String endTime, double lat, double long) async {
    var endpointUrl = 'https://dev-myflxbx-rest.azurewebsites.net/api/1/compartments';
    var qParams = 'startTime=2018-12-24T08%3A00%3A00%2B00%3A00&endTime=2018-12-24T16%3A00%3A00%2B00%3A00';
    var requestUrl = endpointUrl + '?' + qParams;
    var response = await http.get(Uri.parse(requestUrl),
      headers: {
        HttpHeaders.authorizationHeader:
        "Basic 77+977+90IcGI++/vVQhWjDvv73vv70R77+9Nh/vv70yVTIoe++/vRDvv71WVwBd77+9"
      },);

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

}