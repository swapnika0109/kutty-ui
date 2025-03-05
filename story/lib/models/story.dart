class Story {
  final String id;
  final String title;
  final String description;
  final String themeId;
  final String storyText;
  final String base64Image;
  final String imageUrl;

  Story({
    this.id = '',
    required this.title,
    required this.description,
    this.themeId = '',
    this.storyText = '',
    this.base64Image = '',
    this.imageUrl = '',
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    // Handle API response format
    return Story(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      themeId: json['theme_id']?.toString() ?? '',
      storyText: json['story_text'] ?? json['content'] ?? '',
      base64Image: json['image'] ?? '',
    );
  }

  // Helper method to get the image for display
  String getDisplayImage() {
    if (base64Image.isNotEmpty) {
      return base64Image;
    }
    return imageUrl;
  }

  // Helper method to check if image is base64
  bool isBase64Image() {
    return base64Image.isNotEmpty;
  }
}
