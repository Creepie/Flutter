import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'models/google_places_data.dart';

class GooglePlacesRepo {
  final client = Client();

  GooglePlacesRepo();

  static final String androidKey = 'AIzaSyAa1wlxqTxIhb5In_fBqQpjGnaISoh11Co';
  static final String iosKey = 'AIzaSyAa1wlxqTxIhb5In_fBqQpjGnaISoh11Co';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=de&components=country:at&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<MyLocationData> getPlaceDetailFromId(String placeId, String placeDescription) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        print(result['result']['geometry']['location']);
        final components =
        result['result']['geometry']['location'] as Map<String, dynamic>;
        // build result
        final location = MyLocationData();
        location.lat = components["lat"];
        location.long = components["lng"];
        location.description = placeDescription;
        return location;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}