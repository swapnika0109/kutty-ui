import 'package:flutter/material.dart';
import 'package:story/widgets/gradient_scaffold.dart';

class StoryListPage extends StatelessWidget {
  final String title;

  StoryListPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStoryCard(
            'The Green Guardian',
            'assets/images/story1.jpg',
            'A tale of a young hero saving the forests.',
          ),
          _buildStoryCard(
            'Mindful Journey',
            'assets/images/story2.jpg',
            'Explore the depths of mindfulness and peace.',
          ),
          _buildStoryCard(
            'The Art of Slow Living',
            'assets/images/story3.jpg',
            'Learn to live life at a slower, more meaningful pace.',
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(String title, String imagePath, String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
