import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weaterhui/module/error.dart';

import '../module/weather.dart';

class SearchLocation extends ChangeNotifier {
  Future getData(String City) async {
    try {
      var response = await get(
          Uri.parse(
              "https://weatherapi-com.p.rapidapi.com/forecast.json?q=$City&days=3"),
          headers: {
            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com",
            "X-RapidAPI-Key":
                "d3f7088ea3msh20be116c86008d7p1dc4c2jsn3ba0c68fb6b6"
          });

      notifyListeners();
      if (response.statusCode != 400) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        ErrorDescription("No matching location found");
      }
    } on SocketException catch (e) {
      throw Exception(e.message);
    } on PermissionDeniedException catch (e) {
      throw Exception(e.message);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
