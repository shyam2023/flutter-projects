// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weaterhui/module/current_weather.dart';
import 'package:weaterhui/provider/SearchLocation.dart';
import 'package:weaterhui/provider/currentweatherprovider.dart';
import 'package:weaterhui/provider/weatherprovider.dart';
import 'package:weaterhui/utils/dimension.dart';
import 'package:weaterhui/utils/getlocation.dart';
import 'package:weaterhui/widget/homewidget/BigText.dart';
import 'package:weaterhui/widget/homewidget/FixedHeightText.dart';
import 'package:weaterhui/widget/homewidget/draggableScrollablesheet.dart';
import 'package:weaterhui/widget/homewidget/navigationButton.dart';

import '../utils/location.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({Key? key}) : super(key: key);

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocation();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController City = TextEditingController();

    var something = context.read<currentWeatherProvider>();
    print("position is ${long},${lat}");
    //
    // currentlocationData() async {
    //   Position position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high);
    //   setState(() {
    //     long = position.longitude.toString();
    //     lat = position.latitude.toString();
    //   });
    //   // return ("${position.latitude}, ${position.longitude}");

    //   setState(() {
    //     long = position.longitude.toString();
    //     lat = position.latitude.toString();
    //   });}

    return Scaffold(
      backgroundColor: Color(0xff060721),
      bottomNavigationBar: ButtonNavigation(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                FutureBuilder(
                    future: something.searchData("$lat,$long"),
                    builder: (BuildContext context, AsyncSnapshot snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapShot.hasError) {
                        return BigText(text: "${snapShot.error}");
                      } else if (snapShot.hasData) {
                        final data = snapShot.data;
                        //print("the log is $long, $lat");

                        return Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              BigText(text: "Pic Locaiton"),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              BigText(
                                text:
                                    "find the area or city that you want to know\n the detailed weather info at this time",
                                size: 12,
                                color: Colors.white24,
                              ),
                              SizedBox(height: Dimensions.height20),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: Dimensions.width20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: Dimensions.height70,
                                      width: Dimensions.width230,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.white),
                                        controller: City,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          prefixIcon: Icon(Icons.search,
                                              color: Colors.white),
                                          filled: true,
                                          fillColor: Color(0XFF23214b),
                                          hintText: "Search",
                                          hintStyle:
                                              TextStyle(color: Colors.white12),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width20),
                                    GestureDetector(
                                      onTap: () {
                                        if (formkey.currentState!.validate()) {
                                          showModalBottomSheet(
                                            backgroundColor: Color(0xff080931),
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) =>
                                                DraggableSheet(City: City.text),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: Dimensions.height50,
                                        width: Dimensions.width50,
                                        decoration: BoxDecoration(
                                          color: Color(0xff222249),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.location_pin,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Flexible(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: index != 3 & 1
                                            ? EdgeInsets.only(
                                                top: Dimensions.height20,
                                                left: Dimensions.width10,
                                                bottom: 0)
                                            : EdgeInsets.only(
                                                left: Dimensions.width10,
                                                top: Dimensions.height40,
                                                bottom: 0),
                                        height: Dimensions.height120,
                                        width: Dimensions.width150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: index != 0
                                              ? Color(0xff0d0d28)
                                              : Colors.blue,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Dimensions.width20,
                                                  top: Dimensions.height20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  BigText(
                                                    text:
                                                        '${data.current.tempC}\u2103',
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimensions.height10),
                                                  FixedHeightWidthText(
                                                    text:
                                                        '${data.current.condition.text}',
                                                    size: 10,
                                                    color: Colors.white24,
                                                  ),
                                                  SizedBox(height: 20),
                                                  BigText(
                                                    text:
                                                        '${data.location.name}',
                                                    size: 15,
                                                    color: Colors.white60,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              height: Dimensions.height50,
                                              width: Dimensions.width50,
                                              child: Image.network(
                                                'https:${data.current.condition.icon}',
                                              ),
                                            ),

                                            // color: Colors.white,
                                          ],
                                        ),
                                      );
                                    }),
                              )

                              // Column(
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Container(
                              //           height: 120,
                              //           width: 150,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(12),
                              //             color: Colors.blue,
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 20, top: 20),
                              //                 child: Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     BigText(
                              //                       text: '${data.current.tempC}',
                              //                       size: 20,
                              //                     ),
                              //                     SizedBox(height: 10),
                              //                     BigText(
                              //                       text: 'Cloudy',
                              //                       size: 13,
                              //                       color: Colors.white24,
                              //                     ),
                              //                     SizedBox(height: 20),
                              //                     BigText(
                              //                       text: '${data.location.name}',
                              //                       size: 15,
                              //                       color: Colors.white60,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Icon(
                              //                 Icons.cloud,
                              //                 size: 60,
                              //                 color: Colors.white,
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Container(
                              //           margin:
                              //               EdgeInsets.only(left: 20, top: 40),
                              //           height: 120,
                              //           width: 150,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(12),
                              //             color: Color(0xff0d0d28),
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 20, top: 20),
                              //                 child: Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     BigText(
                              //                       text: '${data.current.tempC}',
                              //                       size: 20,
                              //                     ),
                              //                     SizedBox(height: 10),
                              //                     BigText(
                              //                       text: 'Cloudy',
                              //                       size: 13,
                              //                       color: Colors.white24,
                              //                     ),
                              //                     SizedBox(height: 20),
                              //                     BigText(
                              //                       text: 'California',
                              //                       size: 15,
                              //                       color: Colors.white60,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Icon(Icons.cloud,
                              //                   size: 60, color: Colors.white),
                              //             ],
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       height: 30,
                              //     ),

                              //     //second row of the pick locaiton

                              //     Row(
                              //       children: [
                              //         Container(
                              //           height: 120,
                              //           width: 150,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(12),
                              //             color: Color(0xff0d0d28),
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 20, top: 20),
                              //                 child: Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     BigText(
                              //                       text: '${data.current.tempC}',
                              //                       size: 20,
                              //                     ),
                              //                     SizedBox(height: 10),
                              //                     BigText(
                              //                       text: 'Cloudy',
                              //                       size: 13,
                              //                       color: Colors.white24,
                              //                     ),
                              //                     SizedBox(height: 20),
                              //                     BigText(
                              //                       text: 'California',
                              //                       size: 15,
                              //                       color: Colors.white60,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Icon(
                              //                 Icons.cloud,
                              //                 size: 60,
                              //                 color: Colors.white,
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //         Container(
                              //           margin:
                              //               EdgeInsets.only(left: 20, top: 40),
                              //           height: 120,
                              //           width: 150,
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(12),
                              //             color: Color(0xff0d0d28),
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 20, top: 20),
                              //                 child: Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     BigText(
                              //                       text: '32',
                              //                       size: 20,
                              //                     ),
                              //                     SizedBox(height: 10),
                              //                     BigText(
                              //                       text: 'Cloudy',
                              //                       size: 13,
                              //                       color: Colors.white24,
                              //                     ),
                              //                     SizedBox(height: 20),
                              //                     BigText(
                              //                       text: 'California',
                              //                       size: 15,
                              //                       color: Colors.white60,
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Icon(Icons.cloud,
                              //                   size: 60, color: Colors.white),
                              //             ],
                              //           ),
                              //         )
                              //       ],
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ],
            ),
            // child: Column(
            //   children: [
            //     SizedBox(
            //       height: 20,
            //     ),
            //     BigText(text: "${so}"),
            //     SizedBox(height: 20),

            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
