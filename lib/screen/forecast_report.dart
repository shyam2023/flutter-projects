// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:weaterhui/provider/weatherprovider.dart';
import 'package:weaterhui/screen/pick_location.dart';
import 'package:weaterhui/utils/dimension.dart';
import 'package:weaterhui/widget/homewidget/BigText.dart';
import 'package:weaterhui/widget/homewidget/navigationButton.dart';
import 'package:weaterhui/widget/homewidget/weather_container.dart';

import '../utils/location.dart';

class ForecastReport extends StatefulWidget {
  const ForecastReport({Key? key}) : super(key: key);

  @override
  State<ForecastReport> createState() => _ForecastReportState();
}

class _ForecastReportState extends State<ForecastReport> {
  var long;
  var lat;
  Future getlocation() async {
    Position p = await LocationPosition().getGeoLocationPosition();
    setState(() {
      lat = p.latitude;
      long = p.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    var something = context.read<WeatherProvidr>();
    DateTime DayOfWeek;
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return Scaffold(
        backgroundColor: Color(0xff080931),
        bottomNavigationBar: ButtonNavigation(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: FutureBuilder(
                  future: something.getData("$lat,$long"),
                  builder: (BuildContext context, AsyncSnapshot snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapShot.hasError) {
                      return BigText(text: "${snapShot.error}");
                    }
                    if (snapShot.hasData) {
                      final data = snapShot.data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Dimensions.height20),
                          BigText(text: "Forecast report"),
                          Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.height20,
                                left: Dimensions.width20,
                                right: Dimensions.width20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BigText(text: "Today", size: 15),
                                BigText(
                                    text:
                                        "${data.forecast.forecastday[0].date}")
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),

                          // onTap: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => PickLocation()));
                          // },
                          // child: Expanded(
                          //   child: Container(
                          //     height: 40,
                          //     child: ListView.builder(
                          //         shrinkWrap: true,
                          //         scrollDirection: Axis.horizontal,
                          //         itemCount: data['forecast']['forecastday']
                          //                 [0]['hour']
                          //             .length,
                          //         itemBuilder: (BuildContext context, index) {
                          //           return WeatherContainer(
                          //             height: 60,
                          //             width: 150,
                          //             cloudIcon: data['forecast']
                          //                     ['forecastday'][0]['hour']
                          //                 [index]['condition']['icon'],
                          //             temp:
                          //                 "${data['forecast']['forecastday'][0]['hour'][index]['temp_c']}\u2103",
                          //             time:
                          //                 "${DateFormat.Hm().format(DateTime.parse('${data['forecast']['forecastday'][0]['hour'][index]['time']}'))}",
                          //             containerColor: Color(0xff1c85e6),
                          //           );
                          //         }),
                          //   ),
                          // ),

                          Flexible(
                            child: SizedBox(
                              height: Dimensions.height100,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PickLocation()));
                                },
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    // itemCount:
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
                                            "${DateFormat.Hm().format(DateTime.parse('${data.forecast.forecastday[0].hour[index].time}'))}",
                                        containerColor: Color(0xff1c85e6),
                                      );
                                      // return Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Container(
                                      //       height: 100,
                                      //       width: 100,
                                      //       color: Colors.red),
                                      // );
                                    }),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BigText(text: "Next forecost"),
                                InkWell(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime(2100));
                                    },
                                    child: Icon(Icons.date_range_outlined,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),

                          //container for weather forecast

                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: data.forecast.forecastday.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, index) {
                                DayOfWeek = DateFormat("yyyy-MM-dd").parse(
                                    "${data.forecast.forecastday[index].date}");

                                return Container(
                                  margin: EdgeInsets.all(Dimensions.height10),
                                  height: Dimensions.height100,
                                  width: Dimensions.width300,
                                  decoration: BoxDecoration(
                                    color: Color(0xff0d0d28),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: Dimensions.width20),
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "${DateFormat('EEEE').format(DayOfWeek)}\n",
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 20)),
                                              TextSpan(
                                                text:
                                                    '\ ${months[DayOfWeek.month - 1]}, ${DayOfWeek.day}',
                                                style: TextStyle(
                                                    color: Colors.white24),
                                              ),
                                            ]),
                                          )),
                                      BigText(
                                        text:
                                            "${data.forecast.forecastday[index].day.maxtempC}\u2103",
                                        size: 30,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: Dimensions.width20),
                                        child: Image(
                                            image: NetworkImage(
                                                "https:${data.forecast.forecastday[index].day.condition.icon}")),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return BigText(text: "there is no data available");
                    }
                  }),
            ),
          ),
        ));
  }
}
