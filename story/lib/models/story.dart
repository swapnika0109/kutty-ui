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
    // If it's a base64 image that doesn't have the data:image prefix, add it
    if (base64Image.startsWith('/9j/')) {
      return 'data:image/jpeg;base64,' + base64Image;
    }
    return base64Image;
  }

  // Helper method to check if image is base64
  bool isBase64Image() {
    return base64Image.startsWith('data:image') ||
        base64Image.startsWith('/9j/');
  }
}
