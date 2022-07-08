// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';

import 'Screens/face_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter FaceDetector'),
    );
  }
}
