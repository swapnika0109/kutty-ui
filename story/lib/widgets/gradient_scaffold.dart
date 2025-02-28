import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  GradientScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.purple,
          ], // Define the colors for the gradient
          begin: Alignment.topLeft, // Start point of the gradient
          end: Alignment.bottomRight, // End point of the gradient
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make Scaffold background transparent
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
