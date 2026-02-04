import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';

class UrgentUpdateDataModel {
  String chipText;
  String titleText;
  String bodyText;
  String timeText;
  UrgentUpdateDataModel({
    required this.chipText,
    required this.titleText,
    required this.bodyText,
    required this.timeText,
  });
  factory UrgentUpdateDataModel.fromFirestore(
    Map<String, dynamic> firestoreData,
  ) {
    final postTime = firestoreData['post_time'] as Timestamp;
    final postDate = postTime.toDate();

    String timeAgo = Dateformatter.getTimeAgo(postDate);

    // Replace the raw timestamp in the map with the formatted string so the return uses it
    firestoreData['post_time'] = timeAgo;
    return UrgentUpdateDataModel(
      chipText: firestoreData['chipText'] ?? '',
      titleText: firestoreData['title'] ?? '',
      bodyText: firestoreData['description'] ?? '',
      timeText: timeAgo,
    );
  }
}
