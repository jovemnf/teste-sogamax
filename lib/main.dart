import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sogamax_canhotos/screens/barcode/index.dart';
import 'package:sogamax_canhotos/screens/camera/index.dart';
import 'file:///C:/Users/walla/StudioProjects/sogamax_canhotos/lib/screens/login/index.dart';
import 'file:///C:/Users/walla/StudioProjects/sogamax_canhotos/lib/screens/start/index.dart';
import 'screens/home/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/barcode': (context) => BarcodePage(),
        '/camera': (context) => CameraPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartPage(),
    );
  }
}
