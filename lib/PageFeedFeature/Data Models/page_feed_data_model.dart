class PageFeedDataModel {
  String courseName;
  int pageId;
  String pageType;

  PageFeedDataModel({
    required this.courseName,
    required this.pageId,
    required this.pageType,
  });

  factory PageFeedDataModel.fromMap(Map<String, dynamic> map) {
    return PageFeedDataModel(
      courseName: map['courses']['course_name'] ?? '',
      pageId: map['id'] ?? 0,
      pageType: map['type'] ?? '',
    );
  }
}
