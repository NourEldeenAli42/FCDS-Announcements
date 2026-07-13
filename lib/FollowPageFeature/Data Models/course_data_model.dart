class CourseDataModel {
  final int id;
  final String name;
  final String description;
  final int credits;

  CourseDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
  });
  factory CourseDataModel.fromDocument(Map<String, dynamic> doc) {
    return CourseDataModel(
      id: doc['id'] ?? '',
      name: doc['course_name'] ?? '',
      description: doc['description'] ?? '',
      credits: doc['credits'] ?? 0,
    );
  }
}
