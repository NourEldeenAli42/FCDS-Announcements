class InstructorDataModel {
  final int id;
  final String name;
  final bool doctor;

  InstructorDataModel({
    required this.id,
    required this.name,
    required this.doctor,
  });

  factory InstructorDataModel.fromJson(Map<String, dynamic> json) {
    return InstructorDataModel(
      id: json['id'],
      name: json['instructor_name'],
      doctor: json['doctor'],
    );
  }
}
