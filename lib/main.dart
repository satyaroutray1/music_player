import 'package:flutter/material.dart';
import 'package:mp/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}