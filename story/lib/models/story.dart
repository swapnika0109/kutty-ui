class Story {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String themeId;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.themeId,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      themeId: json['theme_id'],
    );
  }
}
