import 'package:flutter/material.dart';
import '../models/story.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:async';

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
  late List<String> _storyLines;
  bool _isPlaying = false;
  int _currentLineIndex = 0;
  Timer? _playTimer;
  late Widget _storyImage;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    print('DEBUG: initState called');
    _initializeStory();
    _initializeImage();
    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_storyImage is Image) {
      precacheImage((_storyImage as Image).image, context);
    }
  }

  void _setupAnimations() {
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    );
  }

  void _initializeImage() {
    try {
      final imageData = widget.story.base64Image;
      print('Image data length: ${imageData.length}');

      if (imageData.isEmpty) {
        print('No image data available');
        _storyImage = _buildPlaceholder();
        return;
      }

      try {
        // Extract the actual base64 data, handling both formats
        String cleanBase64;
        if (imageData.contains(',')) {
          cleanBase64 = imageData.split(',')[1];
        } else {
          cleanBase64 = imageData;
        }

        // Remove any whitespace or newlines that might have gotten in
        cleanBase64 = cleanBase64.trim();

        print('Clean base64 length: ${cleanBase64.length}');
        final imageBytes = base64Decode(cleanBase64);

        _storyImage = Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            print('Error displaying image: $error');
            return _buildPlaceholder();
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: child,
            );
          },
        );
      } catch (e, stackTrace) {
        print('Error decoding base64: $e');
        print('Stack trace: $stackTrace');
        _storyImage = _buildPlaceholder();
      }
    } catch (e, stackTrace) {
      print('Error in _initializeImage: $e');
      print('Stack trace: $stackTrace');
      _storyImage = _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1A4C), Color(0xFF1E1A3C)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_rounded, color: Colors.white24, size: 64),
            SizedBox(height: 16),
            Text(
              'Story Time!',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeStory() {
    print('DEBUG: Starting story initialization');
    print('DEBUG: Story object: ${widget.story}');
    print('DEBUG: Raw story text: "${widget.story.storyText}"');

    // Add null check and provide default empty string if storyText is null
    final storyText = widget.story.storyText ?? '';

    if (storyText.isEmpty) {
      print('DEBUG: Story text is empty');
      setState(() {
        _storyLines = ['This story will be available soon!'];
        _currentLineIndex = 0;
      });
      return;
    }

    // Remove any leading/trailing whitespace and split by newlines
    final lines =
        storyText
            .trim()
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    print('DEBUG: Processed ${lines.length} lines');

    setState(() {
      _storyLines = lines;
      _currentLineIndex = 0;
    });

    // Print each line for debugging
    _storyLines.asMap().forEach((index, line) {
      print('DEBUG: Line $index: "$line"');
    });
  }

  @override
  void didUpdateWidget(StoryPlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('DEBUG: didUpdateWidget called');
    if (oldWidget.story.storyText != widget.story.storyText) {
      print('DEBUG: Story text changed, reinitializing');
      _initializeStory();
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startReading();
      } else {
        _playTimer?.cancel();
      }
    });
  }

  void _startReading() {
    _playTimer?.cancel();
    _playTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentLineIndex < _storyLines.length - 1) {
        setState(() => _currentLineIndex++);
      } else {
        timer.cancel();
        setState(() {
          _isPlaying = false;
          _currentLineIndex = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _playTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1A3C),
      body: Stack(
        children: [
          // Animated background decorations
          Positioned(
            right: -30,
            top: -30,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 5 * _bounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF7B9C), Color(0xFFFF5D8F)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: 160,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -8 * _bounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF7B9CFF), Color(0xFF5D8FFF)],
                  ),
                ),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // Styled image section
              Container(
                height: 400,
                child: Stack(
                  children: [
                    // Image container with fun frame
                    Padding(
                      padding: EdgeInsets.fromLTRB(40, 60, 40, 40),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF7B9CFF).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: _storyImage,
                        ),
                      ),
                    ),
                    // Fun back button
                    Positioned(
                      left: 50,
                      top: 70,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF7B9C),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF7B9C).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    // Playful title section
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xFF1E1A3C)],
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '🌟 STORY TIME 🌟',
                              style: TextStyle(
                                color: Color(0xFFFF7B9C),
                                fontSize: 16,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.story.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Story content with fun styling
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(20),
                          child:
                              _storyLines.isEmpty
                                  ? Center(
                                    child: Text(
                                      'No story content available',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: _storyLines.length,
                                    itemBuilder: (context, index) {
                                      final isCurrentLine =
                                          index == _currentLineIndex;
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        margin: EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              isCurrentLine
                                                  ? Color(
                                                    0xFF7B9CFF,
                                                  ).withOpacity(0.15)
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border:
                                              isCurrentLine
                                                  ? Border.all(
                                                    color: Color(
                                                      0xFF7B9CFF,
                                                    ).withOpacity(0.3),
                                                  )
                                                  : null,
                                        ),
                                        child: Row(
                                          children: [
                                            if (isCurrentLine) ...[
                                              Text(
                                                "🎵 ",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                            Expanded(
                                              child: Text(
                                                _storyLines[index],
                                                style: TextStyle(
                                                  color:
                                                      isCurrentLine
                                                          ? Colors.white
                                                          : Colors.white60,
                                                  fontSize: 18,
                                                  height: 1.6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ),

                      // Super fun controls
                      _buildPlayfulControls(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayfulControls() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.currentIndex > 0)
            _buildControlButton(
              "👈",
              () => _navigateToStory(widget.currentIndex - 1),
              Color(0xFFFF7B9C),
            ),
          SizedBox(width: 20),
          _buildPlayButton(),
          SizedBox(width: 20),
          if (widget.currentIndex < widget.playlist.length - 1)
            _buildControlButton(
              "👉",
              () => _navigateToStory(widget.currentIndex + 1),
              Color(0xFF7B9CFF),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    String emoji,
    VoidCallback onPressed,
    Color color,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(emoji, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildPlayButton() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.1 * _bounceAnimation.value,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B9CFF), Color(0xFFFF7B9C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7B9CFF).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: _togglePlay,
            ),
          ),
        );
      },
    );
  }

  void _navigateToStory(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => StoryPlayerPage(
              story: widget.playlist[index],
              playlist: widget.playlist,
              currentIndex: index,
            ),
      ),
    );
  }
}
