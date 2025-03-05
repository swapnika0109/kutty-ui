import 'package:flutter/material.dart';
import '../models/story.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1B35),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1B35), Color(0xFF16213E)],
            ),
          ),
          child: Column(
            children: [
              // Header with story title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'NOW PLAYING',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.story.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Story Image with animation
              Expanded(
                flex: 3,
                child: TweenAnimationBuilder(
                  duration: Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _lineColors[_currentLineIndex %
                                      _lineColors.length]
                                  .withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                          border: Border.all(
                            color: _lineColors[_currentLineIndex %
                                    _lineColors.length]
                                .withOpacity(0.3),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.story.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Story Text Area
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        _storyLines.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: index == _currentLineIndex ? 12 : 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                index <= _currentLineIndex
                                    ? _lineColors[index % _lineColors.length]
                                        .withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                index == _currentLineIndex
                                    ? Border.all(
                                      color:
                                          _lineColors[index %
                                              _lineColors.length],
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: Text(
                            _storyLines[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  index <= _currentLineIndex
                                      ? _lineColors[index % _lineColors.length]
                                      : Colors.white.withOpacity(0.3),
                              fontSize: index == _currentLineIndex ? 28 : 24,
                              fontWeight:
                                  index == _currentLineIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentLineIndex + 1) / _storyLines.length,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _lineColors[_currentLineIndex % _lineColors.length],
                        ),
                        minHeight: 6,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Story ${widget.currentIndex + 1}',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          'of ${widget.playlist.length}',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Controls
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.skip_previous,
                      onPressed: _previousStory,
                    ),
                    _buildControlButton(
                      icon:
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                      onPressed: _togglePlayPause,
                      size: 48,
                      isPlayButton: true,
                    ),
                    _buildControlButton(
                      icon: Icons.skip_next,
                      onPressed: _nextStory,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
