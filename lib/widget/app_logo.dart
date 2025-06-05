import 'package:flutter/material.dart';

Widget appLogo() {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(vertical: 16.0),
    child: Image.asset(
      'assets/images/logo.png',
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}
