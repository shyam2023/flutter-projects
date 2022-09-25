// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:weaterhui/utils/dimension.dart';

class WeatherContainer extends StatelessWidget {
  double height;
  double width;
  Color containerColor;
  String cloudIcon;
  String time;
  String temp;

  WeatherContainer(
      {Key? key,
      required this.height,
      required this.width,
      this.containerColor = const Color(0xff11112a),
      required this.cloudIcon,
      required this.temp,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.height20,
          left: Dimensions.width10,
          right: Dimensions.width20,
          bottom: Dimensions.height10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(image: NetworkImage('https:${cloudIcon}')),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(temp,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}
