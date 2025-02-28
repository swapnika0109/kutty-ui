import 'package:flutter/material.dart';

class CoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/de6bcd22-25ba-42af-8cf5-cb16a6f9f2bf.jpeg',
            ), // Path to your image
            fit:
                BoxFit.cover, // Adjust the image to cover the entire background
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to CoolPage!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
