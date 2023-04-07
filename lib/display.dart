import 'package:flutter_switch/flutter_switch.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherwise/start.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
//import 'package:clima/utilities/constants.dart';
import 'search.dart';
import 'Network.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(@required this.weatherdata);
  final weatherdata;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late String cityname;
  var weatherdis;
  late double temperature;
  late double temp_f;
  var newname;
  var weathericon;
  var lastup;
  late double feelslike;
  var limit;
  double? temp;
  late int time;
  late Map<String, dynamic> firstMap;
  var firstmaplength;
  late double feels_f;
  List<Map<String, dynamic>> forecastdata = [];
  late String limit1;

  @override
  void initState() {
    getdata(widget.weatherdata);
    print(DateTime.now());
    super.initState();
  }

  void getdata(dynamic finaldata) {
    setState(() {
      cityname = finaldata['location']['name'];
      weatherdis = finaldata['current']['condition']['text'];
      weathericon = finaldata['current']['condition']['icon'];
      temperature = finaldata['current']['temp_c'];
      feelslike = finaldata['current']['feelslike_c'];
      limit = finaldata['location']['localtime_epoch'];
      temp_f = finaldata['current']['temp_f'];
      feels_f = finaldata['current']['feelslike_f'];

      for (int i = 0; i < 24; i++) {
        final hourEpoch =
            finaldata['forecast']['forecastday'][0]['hour'][i]['time_epoch'];

        if (hourEpoch > limit) {
          String time =
              finaldata['forecast']['forecastday'][0]['hour'][i]['time'];
          String hour = time.substring(11, 16);
          forecastdata.add({
            'time': hour,
            'temp_c': finaldata['forecast']['forecastday'][0]['hour'][i]
                ['temp_c'],
            'temp_f': finaldata['forecast']['forecastday'][0]['hour'][i]
                ['temp_f'],
            'condition_text': finaldata['forecast']['forecastday'][0]['hour'][i]
                ['condition']['text'],
            'condition_icon': finaldata['forecast']['forecastday'][0]['hour'][i]
                ['condition']['icon']
          });
        } else if (i == 23) {
          String time =
              finaldata['forecast']['forecastday'][0]['hour'][i]['time'];
          String hour = time.substring(11, 16);
          forecastdata.add({
            'time': hour,
            'temp_c': finaldata['forecast']['forecastday'][0]['hour'][23]
                ['temp_c'],
            'temp_f': finaldata['forecast']['forecastday'][0]['hour'][23]
                ['temp_f'],
            'condition_text': finaldata['forecast']['forecastday'][0]['hour']
                [23]['condition']['text'],
            'condition_icon': finaldata['forecast']['forecastday'][0]['hour']
                [23]['condition']['icon']
          });
        }
      }
      firstMap = forecastdata[0];
      firstmaplength = firstMap.length;
      print(firstmaplength);
    });
  }

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  bool isSwitched = false;

  bool status = false;
  bool light0 = false;
  bool light1 = false;
  bool light2 = true;
  bool far = false;
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(WeatherIcons.celsius);
      }
      return const Icon(WeatherIcons.fahrenheit);
    },
  );

  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((lightColorScheme, darkColorScheme) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            // colorSchemeSeed: const Color(0xff6750a4),
            useMaterial3: true,
          ),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Location_screen()));
                          },
                          child: Icon(Icons.location_on_outlined)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          cityname,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900, fontSize: 20.0),
                        ),
                      ),
                      Spacer(),
                      FloatingActionButton.small(
                        child: Icon(Icons.search_rounded),
                        onPressed: () async {
                          HapticFeedback.vibrate();
                          newname = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Search_location(),
                              ));

                          if (newname != null) {
                            Network network = await Network(
                                'http://api.weatherapi.com/v1/forecast.json?key={api_key}&q=$newname');
                            var newdata = await network.getData();
                            forecastdata.clear();
                            getdata(newdata);
                          }
                        },
                      ),
                      Switch(
                        thumbIcon: thumbIcon,
                        value: far,
                        onChanged: (bool value) {
                          setState(() {
                            far = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Image.network(
                    'http:$weathericon',
                    scale: 0.5,
                  ),
                  Text(
                    weatherdis,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900, fontSize: 20.0),
                  ),
                  far
                      ? Text(
                          temp_f.toInt().toString() + "°F",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900, fontSize: 50.0),
                        )
                      : Text(
                          temperature.toInt().toString() + "°C",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900, fontSize: 50.0),
                        ),
                  far
                      ? Text(
                          "Feels Like: " + feels_f.toInt().toString() + "°F",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900, fontSize: 20.0),
                        )
                      : Text(
                          "Feels Like: " + feelslike.toInt().toString() + "°C",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900, fontSize: 20.0),
                        ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Hourly Forecast',
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold, fontSize: 30.0),
                      )),
                  Flexible(
                    child: ListView.builder(
                      //shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: forecastdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        final hourData = forecastdata[index];
                        return Card(
                          margin: EdgeInsets.only(
                              left: 50.0, right: 50.0, bottom: 10.0),
                          elevation: 0,
                          child: SizedBox(
                            width: 100,
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hourData["time"],
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(height: 10),
                                Image.network(
                                  "https:${hourData["condition_icon"]}",
                                  // width: 70,
                                  // height: 70,
                                ),
                                // SizedBox(height: 10),
                                Text(
                                  hourData["condition_text"],
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                SizedBox(height: 10),
                                far
                                    ? Text(
                                        "${hourData["temp_f"]} °F",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        "${hourData["temp_c"]} °C",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                SizedBox(
                                  height: 20.0,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
