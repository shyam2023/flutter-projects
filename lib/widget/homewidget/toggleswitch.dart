import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weaterhui/utils/dimension.dart';

class Toggle extends StatelessWidget {
  const Toggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: Dimensions.width200,
      minHeight: Dimensions.height45,
      cornerRadius: 15,
      fontSize: 16,
      activeBgColor: [Color(0xff1c85e6)],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.black26,
      inactiveFgColor: Colors.white,
      labels: ['Forecast', 'Air quality'],
      totalSwitches: 2,
      onToggle: (index) {
        print("Selected items posion $index");
      },
    );
  }
}
