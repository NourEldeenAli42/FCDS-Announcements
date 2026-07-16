class CourseDataModel {
  final int id;
  final String name;
  final String description;
  final int credits;

  const CourseDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.credits,
  });
  const CourseDataModel.empty({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.credits = 0,
  });
  factory CourseDataModel.fromDocument(Map<String, dynamic> doc) {
    return CourseDataModel(
      id: doc['id'] ?? 0,
      name: doc['course_name'] ?? '',
      description: doc['description'] ?? '',
      credits: doc['credits'] ?? 0,
    );
  }
}
