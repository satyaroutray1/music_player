import 'package:flutter/material.dart';
import 'package:mp/view/ui/home.dart';

import 'model/DB.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      title: 'My Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}