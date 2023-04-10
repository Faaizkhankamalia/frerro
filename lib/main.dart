import 'package:flutter/material.dart';
import 'package:frerro/all%20screens/main_screen.dart';

import 'auth/loginScreen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rider App',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}