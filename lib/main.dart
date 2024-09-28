import 'package:flutter/material.dart';
import 'package:first_flutter_project/weatherApp.dart';

void main() {
  runApp(const MyOwnApp());
}

class MyOwnApp extends StatefulWidget {
  const MyOwnApp({super.key});

  @override
  State<MyOwnApp> createState() => _MyOwnAppState();
}

class _MyOwnAppState extends State<MyOwnApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WeatherPage(),
    );
  }
}
