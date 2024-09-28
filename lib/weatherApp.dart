import 'dart:convert';
import 'dart:ui';

import 'package:first_flutter_project/additional_Information.dart';
import 'package:first_flutter_project/hourly_Forecast.dart';
import 'package:first_flutter_project/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Delhi';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An Unexpected Error Occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather2() async {
    try {
      final res2 = await http.get(
        Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$openWeatherAPIKey2&q=Delhi,India&days=10&aqi=yes&alerts=no',
        ),
      );
      final data2 = jsonDecode(res2.body);
      return data2;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {}),
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          final weatherData = data['list'][0];
          final currentTemp = weatherData['main']['temp'];
          final currentSky = weatherData['weather'][0]['main'];
          final currentPressure = weatherData['main']['pressure'];
          final currentHumidity = weatherData['main']['humidity'];
          final currentWindSpeed = weatherData['wind']['speed'];

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card

                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //weather forcast cards
                  const SizedBox(
                    height: 5,
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 1; i <= 20; i++)
                  //         HourlyForecast(
                  //           time: ['dt'].toString(),
                  //           icon: data['list'][i]['weather'][0]['main'] ==
                  //                       'Clouds' ||
                  //                   data['list'][i]['weather'][0]['main'] ==
                  //                       'Rain'
                  //               ? Icons.cloud
                  //               : Icons.sunny,
                  //           value: data['list'][i]['main']['temp'].toString(),
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final hourlySky =
                              data['list'][index + 1]['weather'][0]['main'];
                          final time = DateTime.parse(hourlyForecast['dt_txt']);
                          return HourlyForecast(
                            time: DateFormat.j().format(time),
                            icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            value: hourlyForecast['main']['temp'].toString(),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInformation(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.air,
                        label: 'wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Air Quality Index',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.masks,
                                size: 20,
                              ),
                              Text('106'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
