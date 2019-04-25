import 'package:flutter/material.dart';
import 'cookbook_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 206, 0, 1),
      ),
      home: CookBookPage(),
    );
  }
}
