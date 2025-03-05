import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/story_service.dart';
import 'dart:convert';

class StoryPlayerPage extends StatefulWidget {
  final Story story;
  final List<Story> playlist;
  final int currentIndex;

  StoryPlayerPage({
    required this.story,
    required this.playlist,
    required this.currentIndex,
  });

  @override
  _StoryPlayerPageState createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentLineIndex = 0;
  late List<String> _storyLines;

  final StoryService _storyService = StoryService();

  // Colors for different lines with more vibrant, kid-friendly colors
  final List<Color> _lineColors = [
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFF4ECDC4), // Turquoise
    Color(0xFFFFBE0B), // Yellow
    Color(0xFF7209B7), // Purple
    Color(0xFF06D6A0), // Mint Green
    Color(0xFFFF006E), // Pink
  ];

  // Dummy story content - replace with actual story content
  final List<String> _dummyStoryContent = [
    "Once upon a time, in a magical forest,",
    "there lived a wise old owl named Oliver.",
    "He loved to teach young animals about nature,",
    "and the importance of protecting their home.",
    "Every evening, as the sun set behind the trees,",
    "animals would gather around to hear his stories.",
  ];

  @override
  void initState() {
    super.initState();
    _storyLines = _dummyStoryContent;
    _startStoryTimer();
  }

  void _startStoryTimer() {
    Future.delayed(Duration(seconds: 2), () {
      if (_isPlaying && mounted) {
        if (_currentLineIndex < _storyLines.length - 1) {
          setState(() {
            _currentLineIndex++;
          });
          _startStoryTimer();
        }
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startStoryTimer();
      }
    });
  }

  void _nextStory() {
    if (widget.currentIndex < widget.playlist.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => StoryPlayerPage(
                story: widget.playlist[widget.currentIndex + 1],
                playlist: widget.playlist,
                currentIndex: widget.currentIndex + 1,
              ),
        ),
      );
    }
  }

  void _previousStory() {
    if (widget.currentIndex > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => StoryPlayerPage(
                story: widget.playlist[widget.currentIndex - 1],
                playlist: widget.playlist,
                currentIndex: widget.currentIndex - 1,
              ),
        ),
      );
    }
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 36,
    bool isPlayButton = false,
  }) {
    Color buttonColor = _lineColors[_currentLineIndex % _lineColors.length];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(isPlayButton ? 16 : 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isPlayButton
                    ? buttonColor.withOpacity(0.1)
                    : Colors.transparent,
            border: Border.all(
              color: buttonColor.withOpacity(isPlayButton ? 1 : 0.5),
              width: isPlayButton ? 2 : 1,
            ),
            boxShadow:
                isPlayButton
                    ? [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                    : [],
          ),
          child: Icon(icon, color: buttonColor, size: size),
        ),
      ),
    );
  }

  Widget _buildStoryImage(Story story) {
    if (story.isBase64Image()) {
      return Image.memory(
        base64Decode(story.getDisplayImage().split(',').last),
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(story.getDisplayImage(), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.story.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the story image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildStoryImage(widget.story),
            ),
            // Display the story text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.story.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.story.storyText,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            // Add navigation buttons for playlist
            if (widget.playlist.length > 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.currentIndex > 0)
                      ElevatedButton(
                        onPressed: _previousStory,
                        child: Text('Previous Story'),
                      ),
                    if (widget.currentIndex < widget.playlist.length - 1)
                      ElevatedButton(
                        onPressed: _nextStory,
                        child: Text('Next Story'),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
