import 'package:geolocator/geolocator.dart';
import 'location_data.dart';

import 'package:http/http.dart';
import 'dart:convert';
class Locationdata{
   late double longitude;
   late double latitude;
   late dynamic city;
   late dynamic temp;
   late dynamic condition;
  Future<void> getLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    longitude=position.longitude;
    latitude=position.latitude;
  }
}