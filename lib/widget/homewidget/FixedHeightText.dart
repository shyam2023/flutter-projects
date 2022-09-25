// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:weaterhui/utils/dimension.dart';

class FixedHeightWidthText extends StatelessWidget {
  String text;
  double size;
  Color color;

  FixedHeightWidthText(
      {Key? key,
      required this.text,
      this.color = Colors.white,
      this.size = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.height40,
      width: Dimensions.width90,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: size),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
