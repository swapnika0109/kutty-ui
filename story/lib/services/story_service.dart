import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class StoryService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  Future<List<Story>> getStoriesByTheme(String themeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories?theme=$themeId'),
        headers: {
          'Content-Type': 'application/json',
          // Add any required authentication headers here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Story.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      throw Exception('Error fetching stories: $e');
    }
  }

  Future<Story> getStoryDetails(String storyId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories/$storyId'),
        headers: {
          'Content-Type': 'application/json',
          // Add any required authentication headers here
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Story.fromJson(data);
      } else {
        throw Exception('Failed to load story details');
      }
    } catch (e) {
      throw Exception('Error fetching story details: $e');
    }
  }
}
