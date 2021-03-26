class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return description;
  }
}

class MyLocationData {
  double lat;
  double long;
  String description;

  MyLocationData.clone(MyLocationData location)
      : this(
            lat: location.lat,
            long: location.long,
            description: location.description);

  MyLocationData({this.lat, this.long, this.description});
}
