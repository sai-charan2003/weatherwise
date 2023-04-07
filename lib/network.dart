import 'package:http/http.dart';
import 'dart:convert';
class Network{
  Network(this.url);
  final String url;
  Future getData() async{
    Response response = await get(Uri.parse(url));
    String data=response.body;
    return jsonDecode(data);


  }
}