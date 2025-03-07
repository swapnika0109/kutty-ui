import 'package:flutter/material.dart';
import 'package:story/widgets/gradient_scaffold.dart';
import '../services/story_service.dart';
import '../models/story.dart';
import '../screens/story_player_page.dart';
import 'dart:convert';

class ThemesPage extends StatefulWidget {
  @override
  _ThemesPageState createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage>
    with SingleTickerProviderStateMixin {
  int? hoveredIndex;
  int? selectedTheme;
  late AnimationController _controller;
  final StoryService _storyService = StoryService();
  List<Story> _stories = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadStories(int themeIndex) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get stories from API
      final stories = await _storyService.getStories(
        themeId: (themeIndex + 1).toString(),
      );

      print('Received ${stories.length} stories from API');

      if (stories.isEmpty) {
        throw Exception('No stories received from API');
      }

      setState(() {
        _stories = stories;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading stories: $e');
      setState(() {
        _error = 'Failed to load stories. Please try again.';
        _isLoading = false;
        _stories = []; // Clear stories on error
      });
    }
  }

  void _selectTheme(int index) {
    setState(() {
      if (selectedTheme == index) {
        selectedTheme = null;
        _controller.reverse();
        _stories = [];
      } else {
        selectedTheme = index;
        _controller.forward(from: 0);
        _loadStories(index);
      }
    });
  }

  void _onStorySelected(Story story, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StoryPlayerPage(
              story: story,
              playlist: _stories,
              currentIndex: index,
            ),
      ),
    );
  }

  Widget _buildThemeGlobe(String imagePath, String title, int index) {
    bool isSelected = selectedTheme == index;
    return GestureDetector(
      onTap: () => _selectTheme(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        width: 80,
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.black26,
              blurRadius: isSelected ? 12 : 8,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(isSelected ? 0 : 0.2),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    String title,
    String imagePath,
    String description,
    int index,
  ) {
    bool isHovered = hoveredIndex == index;
    bool isSelected = selectedTheme != null;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      transform:
          isSelected
              ? (index == selectedTheme
                    ? Matrix4.identity()
                    : Matrix4.identity()
                ..translate(0.0, 50.0, 0.0)
                ..scale(0.8))
              : Matrix4.identity(),
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIndex = index),
        onExit: (_) => setState(() => hoveredIndex = null),
        child: GestureDetector(
          onTap: () => _selectTheme(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            height: 300,
            transform:
                isHovered
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.005)
                      ..rotateY(0.005)
                      ..scale(1.03)
                      ..translate(0.0, -8.0))
                    : Matrix4.identity(),
            child: TweenAnimationBuilder(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: isHovered ? 1 : 0),
              builder: (context, double value, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.withOpacity(0.2 + (value * 0.08)),
                        Colors.purple.withOpacity(0.1 + (value * 0.08)),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1 + (value * 0.08)),
                        blurRadius: 12 + (value * 6),
                        offset: Offset(-6, -6),
                        spreadRadius: value * 1.5,
                      ),
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.1 + (value * 0.08)),
                        blurRadius: 12 + (value * 6),
                        offset: Offset(6, 6),
                        spreadRadius: value * 1.5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1.0 + (value * 0.3),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            top: isHovered ? -8 : 0,
                            left: isHovered ? -8 : 0,
                            right: isHovered ? -8 : 0,
                            bottom: isHovered ? -8 : 0,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              colorBlendMode: BlendMode.darken,
                              color: Colors.black.withOpacity(
                                0.1 - (value * 0.03),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(
                                    0.6 - (value * 0.08),
                                  ),
                                ],
                                stops: [0.5, 1.0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                  tween: Tween<Offset>(
                                    begin: Offset.zero,
                                    end:
                                        isHovered ? Offset(0, -4) : Offset.zero,
                                  ),
                                  builder: (context, Offset offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 12 + (value * 3),
                                          color: Colors.black54,
                                          offset: Offset(2, 2),
                                        ),
                                        Shadow(
                                          blurRadius: 12 + (value * 3),
                                          color: Colors.blue.withOpacity(
                                            0.3 + (value * 0.15),
                                          ),
                                          offset: Offset(-2, -2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeOutCubic,
                                  tween: Tween<Offset>(
                                    begin: Offset.zero,
                                    end:
                                        isHovered ? Offset(0, -2) : Offset.zero,
                                  ),
                                  builder: (context, Offset offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8 + (value * 2),
                                          color: Colors.black45,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylist() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: Colors.white)),
      );
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: selectedTheme != null ? 1.0 : 0.0,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    // Add autoplay functionality here
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ..._stories.asMap().entries.map((entry) {
              final index = entry.key;
              final story = entry.value;
              return TweenAnimationBuilder(
                duration: Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.translate(
                    offset: Offset(0, (1 - value) * 50),
                    child: Opacity(
                      opacity: value,
                      child: GestureDetector(
                        onTap: () => _onStorySelected(story, index),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => hoveredIndex = index),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  hoveredIndex == index
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    hoveredIndex == index
                                        ? Colors.white30
                                        : Colors.transparent,
                                width: 1,
                              ),
                              boxShadow:
                                  hoveredIndex == index
                                      ? [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        base64Decode(
                                          story.base64Image.split(',').last,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        story.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        story.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.play_arrow,
                                  color:
                                      hoveredIndex == index
                                          ? Colors.white
                                          : Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: Text('Explore Themes')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Theme Globes - Always visible once a selection is made
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: selectedTheme != null ? 100 : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildThemeGlobe(
                      'assets/images/739f99a4-17e2-4068-bb9c-29834db0cfd5.jpeg',
                      'Planet Protectors',
                      0,
                    ),
                    _buildThemeGlobe(
                      'assets/images/c426305a-ce51-4ff7-a0ff-b058a5f83a0e.jpeg',
                      'Mindful Moments',
                      1,
                    ),
                    _buildThemeGlobe(
                      'assets/images/a9c472bb-4419-4607-abf4-9449d75dd683.jpeg',
                      'Chill Champions',
                      2,
                    ),
                  ],
                ),
              ),
              // Theme Cards - Only show when no theme is selected
              if (selectedTheme == null)
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildThemeCard(
                        context,
                        'Planet Protectors',
                        'assets/images/739f99a4-17e2-4068-bb9c-29834db0cfd5.jpeg',
                        'Join the mission to save our planet with engaging stories.',
                        0,
                      ),
                      SizedBox(height: 30),
                      _buildThemeCard(
                        context,
                        'Mindful Moments',
                        'assets/images/c426305a-ce51-4ff7-a0ff-b058a5f83a0e.jpeg',
                        'Discover peace and tranquility through mindful storytelling.',
                        1,
                      ),
                      SizedBox(height: 30),
                      _buildThemeCard(
                        context,
                        'Chill Champions',
                        'assets/images/a9c472bb-4419-4607-abf4-9449d75dd683.jpeg',
                        'Relax and unwind with stories that soothe the soul.',
                        2,
                      ),
                    ],
                  ),
                ),
              // Playlist - Show immediately when a theme is selected
              if (selectedTheme != null) _buildPlaylist(),
            ],
          ),
        ),
      ),
    );
  }
}
