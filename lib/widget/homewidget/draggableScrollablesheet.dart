import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weaterhui/provider/SearchLocation.dart';
import 'package:weaterhui/utils/dimension.dart';
import 'package:weaterhui/widget/homewidget/BigText.dart';
import 'package:weaterhui/widget/homewidget/temwindhumidity.dart';
import 'package:weaterhui/widget/homewidget/toggleswitch.dart';
import 'package:weaterhui/widget/homewidget/weather_container.dart';

import '../../provider/weatherprovider.dart';
import '../../screen/forecast_report.dart';

class DraggableSheet extends StatelessWidget {
  String City;
  DraggableSheet({Key? key, required this.City}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var something = context.read<SearchLocation>();
    print("The name of the city is $City");
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (_, controller) => Container(
        color: Color(0xff080931),
        //padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
                future: something.getData(City),
                builder: (BuildContext context, AsyncSnapshot snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapShot.hasError) {
                    return BigText(text: "${snapShot.hasData}");
                  } else if (snapShot.hasData == null) {
                    return BigText(text: "The value is null");
                  } else if (snapShot.hasData) {
                    final data = snapShot.data;
                    print(data);

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
                            width: Dimensions.height150,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  itemCount:
                                      data.forecast.forecastday[0].hour.length,
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
                    return BigText(text: "No matching location found");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
