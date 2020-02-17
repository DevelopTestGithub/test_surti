

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:surtiSP/models/location_point.dart';

class LocationSearcher {
  static void locationListener(LocationCallback callback) {
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      LocationPoint location = LocationPoint(
          lat: currentLocation.latitude, long: currentLocation.longitude);
      callback(location);
    });
  }

  static void getCurrentLocation(LocationCallbackPetition callback) async {
    LocationData currentLocation;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      LocationPetition petition = LocationPetition(
          location: LocationPoint(
              lat: currentLocation.latitude, long: currentLocation.longitude),
          success: true);
      callback(petition);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print("Give me location");
      }
      currentLocation = null;
      LocationPetition petition = LocationPetition(
          location: LocationPoint(lat: 0, long: 0), success: false);
      callback(petition);
    }
  }
}

typedef void LocationCallback(LocationPoint);
typedef void LocationCallbackPetition(LocationPetition);

class LocationPetition {
  final LocationPoint location;
  final bool success;
  LocationPetition({@required this.location, @required this.success});
}
