import 'package:flutter/material.dart';
import 'package:wave_test/home.dart';

import 'api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.black,
        fontFamily: 'Arial'
      ),
      home: new Home(title: 'Top Stories'),
    );
  }
}