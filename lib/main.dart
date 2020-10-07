import 'package:flutter/material.dart';
import 'package:flutter_send_whatsapp_app/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp Send',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
