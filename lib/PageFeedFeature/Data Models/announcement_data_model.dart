import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementDataModel {
  final int id;
  final DateTime? date;
  final String title;
  final String content;
  final String redirectLink;
  final DateTime? deadline;

  const AnnouncementDataModel({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.redirectLink,
    this.deadline,
  });

  factory AnnouncementDataModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementDataModel(
      id: map['id'] ?? 0,
      date: (DateTime.parse(map['created_at'])),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      redirectLink: map['redirect_link'] ?? '',
      deadline: _parseDeadline(map['deadline']),
    );
  }

  static DateTime? _parseDeadline(dynamic deadline) {
    if (deadline == null) {
      return null;
    }

    // If it's a Timestamp
    if (deadline is Timestamp) {
      return deadline.toDate();
    }

    // If it's a String, try to parse it
    if (deadline is String) {
      try {
        return DateTime.parse(deadline);
      } catch (e) {
        return null;
      }
    }

    // If it's already a DateTime
    if (deadline is DateTime) {
      return deadline;
    }

    return DateTime.parse(deadline);
  }
}
