class CourseDataModel {
  final String id;
  final String name;

  CourseDataModel({required this.id, required this.name});
  factory CourseDataModel.fromDocument(Map<String, dynamic> doc) {
    return CourseDataModel(id: doc['id'] ?? '', name: doc['CourseName'] ?? '');
  }
}
