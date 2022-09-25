import 'package:flutter/material.dart';

class TemWindHumidity extends StatelessWidget {
  String text;
  String number;
  TemWindHumidity({Key? key, required this.text, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 11, color: Colors.white30),
          ),
          Text(
            number,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
