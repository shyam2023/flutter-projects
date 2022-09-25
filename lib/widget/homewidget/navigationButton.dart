// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:weaterhui/screen/forecast_report.dart';
import 'package:weaterhui/screen/home.dart';
import 'package:weaterhui/screen/pick_location.dart';

class ButtonNavigation extends StatefulWidget {
  ButtonNavigation({Key? key}) : super(key: key);

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  final tabs = [HomePage(), PickLocation(), ForecastReport()];
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF060720),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'messages',
            icon: Icon(Icons.messenger),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: Icon(Icons.settings),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });

          Navigator.push(
              context, (MaterialPageRoute(builder: (context) => tabs[index])));
        });
  }
}
