import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:weatherwise/search.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherwise/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'display.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Location_screen extends StatefulWidget {
  Location_screen({Key? key}) : super(key: key);
  @override
  State<Location_screen> createState() => _Location_screenState();
}

class _Location_screenState extends State<Location_screen> {
  var longitude;
  var latitude;
  var long;
  var lat;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Future<void> getLocation() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Search_location()),
          (route) => false);
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    print(longitude);
    longitude = position.longitude;
    latitude = position.latitude;

    Network network = Network(
        'http://api.weatherapi.com/v1/forecast.json?key={api_key}&q=$latitude,$longitude');
    var data = await network.getData();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LocationScreen(data)),
        (route) => false);
  }

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (((lightDynamic, darkDynamic) {
      return MaterialApp(
        theme: ThemeData(
            colorScheme: lightDynamic ?? _defaultLightColorScheme,
            useMaterial3: true),
            darkTheme: ThemeData(colorScheme:darkDynamic??_defaultDarkColorScheme),
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    })));
  }
}
