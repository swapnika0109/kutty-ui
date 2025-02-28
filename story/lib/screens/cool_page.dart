import 'package:flutter/material.dart';
import 'package:story/widgets/gradient_scaffold.dart';

class CoolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Logo Image
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/f39e6127-7194-41c3-95b6-57711e7546e1.jpeg',
                        width: 300,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'AI-Driven Path to Gratitude & Responsibility. \nLet\'s Start the Journey of Learning Through Stories!',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // All images in one line
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildImageCard(
                        'assets/images/de6bcd22-25ba-42af-8cf5-cb16a6f9f2bf.jpeg',
                        width: MediaQuery.of(context).size.width * 0.6,
                        angle: 0.2,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/36fca13d-c3e5-46dc-a17d-cd43ed38d89b.jpeg',
                        width: MediaQuery.of(context).size.width * 0.6,
                        angle: 0.0,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/aa53ce2d-4714-4ad1-ad4a-e51375709cb5.jpeg',
                        width: MediaQuery.of(context).size.width * 0.6,
                        angle: -0.2,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/d65f1452-2bf2-47b1-8d8f-8cd8762db9b3.jpeg',
                        width: MediaQuery.of(context).size.width * 0.6,
                        angle: -0.4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageCard(
    String imagePath, {
    required double width,
    double angle = 0.0,
  }) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width * 0.3,
        height: width * 0.3 * 1.2,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
