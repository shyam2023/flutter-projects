// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:weaterhui/provider/weatherprovider.dart';
import 'package:weaterhui/screen/forecast_report.dart';
import 'package:weaterhui/utils/dimension.dart';
import 'package:weaterhui/utils/location.dart';
import 'package:weaterhui/widget/homewidget/BigText.dart';
import 'package:weaterhui/widget/homewidget/navigationButton.dart';
import 'package:weaterhui/widget/homewidget/temwindhumidity.dart';
import 'package:weaterhui/widget/homewidget/toggleswitch.dart';
import 'package:weaterhui/widget/homewidget/weather_container.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var long;
  var lat;
  Future getlocation() async {
    Position p = await LocationPosition().getGeoLocationPosition();
    setState(() {
      lat = p.latitude;
      long = p.longitude;
    });
    print("position is ${p.longitude}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  @override
  Widget build(BuildContext context) {
    var something = context.read<WeatherProvidr>();

    // print("why not appper");
    // print(Dimensions.screenHeight);
    // print(Dimensions.screenWidth);

    return Scaffold(
      backgroundColor: Color(0xff080931),
      bottomNavigationBar: ButtonNavigation(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: something.getData("$lat,$long"),
                  builder: (BuildContext context, AsyncSnapshot snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapShot.hasError) {
                      final error = snapShot.error;
                      return Text(
                        "$error",
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (snapShot.hasData) {
                      final data = snapShot.data;

                      return Expanded(
                        child: Column(
                          children: [
                            BigText(text: "${data.location.name}"),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            BigText(
                                text: "${data.forecast.forecastday[0].date}",
                                size: 12),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Toggle(),
                            SizedBox(
                              height: Dimensions.height50,
                            ),
                            Container(
                              height: Dimensions.height150,
                              width: Dimensions.width150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https:${data.current.condition.icon}"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TemWindHumidity(
                                    text: "Temp",
                                    number: "${data.current.tempC}\u2103"),
                                TemWindHumidity(
                                    text: "Wind",
                                    number: "${data.current.windKph} km/h"),
                                TemWindHumidity(
                                    text: "Humidity",
                                    number: "${data.current.humidity}%"),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.height40,
                                  left: Dimensions.width20,
                                  right: Dimensions.width20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(text: "Today", size: 18),
                                  TextButton(
                                    onPressed: () {},
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForecastReport()),
                                        );
                                      },
                                      child: BigText(
                                        text: "view full report",
                                        color: Color(0xff123e7c),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: Dimensions.height40,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data
                                        .forecast.forecastday[0].hour.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return WeatherContainer(
                                        height: Dimensions.height60,
                                        width: Dimensions.width150,
                                        cloudIcon: data.forecast.forecastday[0]
                                            .hour[index].condition.icon,
                                        temp:
                                            "${data.forecast.forecastday[0].hour[index].tempC}\u2103",
                                        time:
                                            "${DateFormat.Hm().format(DateTime.parse("${data.forecast.forecastday[0].hour[index].time}"))}",
                                        containerColor: Color(0xff1c85e6),
                                      );
                                    }),
                              ),
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     WeatherContainer(
                            //       height: 70,
                            //       width: 100,
                            //       cloudIcon: Icons.cloud,
                            //       temp: "32",
                            //       time: "14.00",
                            //       containerColor: Color(0xff1c85e6),
                            //     ),
                            //     WeatherContainer(
                            //       height: 70,
                            //       width: 100,
                            //       cloudIcon: Icons.cloud,
                            //       temp: "30",
                            //       time: "15.00",
                            //     ),
                            //     WeatherContainer(
                            //       height: 70,
                            //       width: 100,
                            //       cloudIcon: Icons.cloud,
                            //       temp: "30",
                            //       time: "15.00",
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      );
                    } else {
                      return Text("There is no any data ");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
