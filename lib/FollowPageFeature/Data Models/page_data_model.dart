class PageDataModel {
  final String id;
  final String title; // Mapping to 'Type' or 'Title' based on your UI
  final List<String> tags;

  PageDataModel({
    required this.id,
    required this.title,
    this.tags = const [],
  });

  factory PageDataModel.fromMap(Map<String, dynamic> map) {
    return PageDataModel(
      id: map['id'] ?? '', 
      title: map['Type'] ?? '', 
      tags: List<String>.from(map['Tags'] ?? []),
    );
  }
}