class UserDataModel {
  String id;
  String name;
  String email;
  bool isAdmin;
  UserDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['admin'] as bool,
    );
  }
}
