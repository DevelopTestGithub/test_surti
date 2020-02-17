import 'package:flutter/material.dart';

class LocationPoint {
  LocationPoint({
    @required this.lat,
    @required this.long,
  });
  double long;
  double lat;
}