import 'package:flutter/material.dart';
import 'package:story/screens/cool_page.dart'; // Import CoolPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 32, 126, 172),
        primarySwatch: Colors.blue,
      ),
      home: CoolPage(), // Set CoolPage as the initial screen
    );
  }
}
