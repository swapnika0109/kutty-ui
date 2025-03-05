import '../models/story.dart';

class MockStoryService {
  static final List<Story> _planetProtectorStories = [
    Story(
      id: '1',
      title: 'The Last Tree',
      description: 'A tale of hope and environmental conservation',
      imageUrl: 'assets/images/planet1.jpg',
      themeId: '0',
    ),
    Story(
      id: '2',
      title: 'Ocean Warriors',
      description: 'Join the fight to save marine life',
      imageUrl: 'assets/images/planet2.jpg',
      themeId: '0',
    ),
    Story(
      id: '3',
      title: 'Recycling Heroes',
      description: 'Learn about recycling in a fun way',
      imageUrl: 'assets/images/planet3.jpg',
      themeId: '0',
    ),
  ];

  static final List<Story> _mindfulMomentStories = [
    Story(
      id: '4',
      title: 'Peaceful Garden',
      description: 'A journey through a magical garden',
      imageUrl: 'assets/images/mindful1.jpg',
      themeId: '1',
    ),
    Story(
      id: '5',
      title: 'Breathing Butterfly',
      description: 'Learn mindful breathing with a butterfly friend',
      imageUrl: 'assets/images/mindful2.jpg',
      themeId: '1',
    ),
    Story(
      id: '6',
      title: 'Quiet Forest',
      description: 'Experience tranquility in nature',
      imageUrl: 'assets/images/mindful3.jpg',
      themeId: '1',
    ),
  ];

  static final List<Story> _chillChampionStories = [
    Story(
      id: '7',
      title: 'Sleepy Cloud',
      description: 'Float away on a peaceful cloud',
      imageUrl: 'assets/images/chill1.jpg',
      themeId: '2',
    ),
    Story(
      id: '8',
      title: 'Starlight Dreams',
      description: 'A bedtime story under the stars',
      imageUrl: 'assets/images/chill2.jpg',
      themeId: '2',
    ),
    Story(
      id: '9',
      title: 'Cozy Campfire',
      description: 'Relax by the magical campfire',
      imageUrl: 'assets/images/chill3.jpg',
      themeId: '2',
    ),
  ];

  Future<List<Story>> getStoriesByTheme(String themeId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    switch (themeId) {
      case '0':
        return _planetProtectorStories;
      case '1':
        return _mindfulMomentStories;
      case '2':
        return _chillChampionStories;
      default:
        return [];
    }
  }

  Future<Story> getStoryDetails(String storyId) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    final allStories = [
      ..._planetProtectorStories,
      ..._mindfulMomentStories,
      ..._chillChampionStories,
    ];

    return allStories.firstWhere(
      (story) => story.id == storyId,
      orElse: () => throw Exception('Story not found'),
    );
  }
}
