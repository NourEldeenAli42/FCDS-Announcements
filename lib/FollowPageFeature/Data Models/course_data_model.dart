class CourseDataModel {
  final String id;
  final String name;
  final String description;

  CourseDataModel({required this.id, required this.name, required this.description});
  factory CourseDataModel.fromDocument(Map<String, dynamic> doc) {
    return CourseDataModel(
      id: doc['id'] ?? '',
      name: doc['course_name'] ?? '',
      description: doc['description'] ?? '',
    );
  }
}
