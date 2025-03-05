import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';
import 'mock_story_service.dart';

class StoryService {
  static const String baseUrl = 'http://localhost:8000/api';
  final MockStoryService _mockService = MockStoryService();

  // Replace with your actual API base URLs
  static const String _image_story_api_url = '/story/generate-with-image/';

  Future<List<Story>> getStories({required String themeId}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/story/generate-with-image/'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'theme': themeId,
              'topic': 'dragon tale',
              'type': 'story',
            }),
          )
          .timeout(Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          return data.map((json) => Story.fromJson(json)).toList();
        } else if (data is Map<String, dynamic>) {
          return [Story.fromJson(data)];
        }
      }

      print('Falling back to mock stories due to API response issues');
      return _getMockStories(themeId);
    } catch (e) {
      print('API error, falling back to mock stories: $e');
      return _getMockStories(themeId);
    }
  }

  Future<List<Story>> _getMockStories(String themeId) async {
    // Convert themeId to match mock service format (1-based to 0-based index)
    final mockThemeId = (int.parse(themeId)).toString();
    return await _mockService.getStoriesByTheme(mockThemeId);
  }

  Future<Story> generateStoryWithImage({
    required String theme,
    required String topic,
    required String type,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$_image_story_api_url'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'theme': theme, 'topic': topic, 'type': type}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Story.fromJson(data);
      } else {
        throw Exception('Failed to generate story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating story: $e');
    }
  }
}
