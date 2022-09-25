// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  String text;
  double size;
  Color color;

  BigText(
      {Key? key,
      required this.text,
      this.color = Colors.white,
      this.size = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: size),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
