import 'package:flutter/material.dart';
import 'package:task/screen/appscreen.dart';
import 'package:task/screen/prac.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: appscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
