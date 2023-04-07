import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search_location extends StatefulWidget {
  const Search_location({Key? key}) : super(key: key);

  @override
  State<Search_location> createState() => _Search_locationState();
}

class _Search_locationState extends State<Search_location> {
  final TextEditingController cityname = TextEditingController();
  @override
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (((lightDynamic, darkDynamic) {
      return MaterialApp(
          theme: ThemeData(
              colorScheme: lightDynamic ?? _defaultLightColorScheme,
              useMaterial3: true),
          darkTheme:
              ThemeData(colorScheme: darkDynamic ?? _defaultDarkColorScheme),
          home: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0,left: 5.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Search Location',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 45.0),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
                  child: TextField(
                    controller: cityname,
                    textInputAction: TextInputAction.search,
                    onSubmitted: ((cityname) {
                      print(cityname);
                      Navigator.pop(context, cityname);
                    }),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.search_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(width: 3.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
    })));
  }
}
