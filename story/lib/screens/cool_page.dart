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
                // Image at the top with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ), // Adjust the radius as needed
                  child: Container(
                    height: 250, // Adjust the height as needed
                    width: 300, // Adjust the width as needed
                    decoration: BoxDecoration(
                      color:
                          Colors
                              .transparent, // Ensure the container is transparent
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3), // Shadow position
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(
                            0.2,
                          ), // Highlight color
                          spreadRadius: -2, // Negative spread for highlight
                          blurRadius: 5, // Blur radius for highlight
                          offset: Offset(0, -3), // Highlight position
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ), // Ensure the image is clipped
                      child: Image.asset(
                        'assets/images/f39e6127-7194-41c3-95b6-57711e7546e1.jpeg',
                        fit: BoxFit.cover, // Ensure the entire image is visible
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ), // Add some space between the image and text
                // Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'AI-Driven Path to Gratitude & Responsibility.\n',
                          style: TextStyle(
                            fontSize: 45,
                            color: Colors.greenAccent, // Blend of green color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Let\'s Start the Journey of Learning Through Stories!\n\n',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Immerse yourself in meaningful stories, much like enjoying a playlist of music.',
                          style: TextStyle(
                            fontSize: 20, // Smaller font size
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Button
                ElevatedButton(
                  onPressed: () {
                    // Define the action when the button is pressed
                  },
                  child: Text('Let\'s Get Started'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Updated button color
                    foregroundColor: const Color.fromARGB(
                      255,
                      15,
                      11,
                      11,
                    ), // Updated text color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 20,
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
                        width: MediaQuery.of(context).size.width * 0.7,
                        angle: 0.2,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/36fca13d-c3e5-46dc-a17d-cd43ed38d89b.jpeg',
                        width: MediaQuery.of(context).size.width * 0.65,
                        angle: 0.0,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/aa53ce2d-4714-4ad1-ad4a-e51375709cb5.jpeg',
                        width: MediaQuery.of(context).size.width * 0.65,
                        angle: -0.2,
                      ),
                      SizedBox(width: 10),
                      buildImageCard(
                        'assets/images/d65f1452-2bf2-47b1-8d8f-8cd8762db9b3.jpeg',
                        width: MediaQuery.of(context).size.width * 0.7,
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
