import 'package:flutter/material.dart';
import 'package:wave_test/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(

        // Определил цвета в стиле NYT
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.black,

        // Шрифт также в стиле NYT
        fontFamily: 'Arial'
      ),
      title: "Top Stories",
      home: new HomePage(title: "Top Stories"),
    );
  }
}