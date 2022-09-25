import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:weaterhui/module/current_weather.dart';
import 'package:weaterhui/module/weather.dart';

class WeatherProvidr extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;
  Map<String, dynamic> _map = {};
  Map<String, dynamic> map() => _map;

  Future getData(String location) async {
    try {
      var response = await get(
          Uri.parse(
              "https://weatherapi-com.p.rapidapi.com/forecast.json?q=$location&days=3"),
          headers: {
            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com",
            "X-RapidAPI-Key":
                "d3f7088ea3msh20be116c86008d7p1dc4c2jsn3ba0c68fb6b6"
          });

      notifyListeners();

      return Weather.fromJson(jsonDecode(response.body));
    } on SocketException catch (e) {
      print(e.message);
      throw HttpException("No internet connection");
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
