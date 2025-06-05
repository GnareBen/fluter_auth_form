import 'package:flutter/material.dart';

Widget appLogo() {
  return Column(
    children: [
      // Image.asset('assets/images/logo.png', width: 100, height: 100),
      FlutterLogo(
        size: 200,
        style: FlutterLogoStyle.horizontal,
        textColor: Colors.deepPurple,
        curve: Curves.easeInOut,
      ),
      Text(
        'MyApp',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    ],
  );
}
