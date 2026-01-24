import 'package:cloud_firestore/cloud_firestore.dart';

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
    final now = DateTime.now();
    final diff = now.difference(postDate);

    String timeAgo;
    if (diff.inSeconds < 60) {
      timeAgo = 'Just Now';
    } else if (diff.inMinutes < 60) {
      if (diff.inMinutes == 1) {
        timeAgo = '1 minute ago';
      } else {
        timeAgo = '${diff.inMinutes} minutes ago';
      }
      timeAgo = '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      timeAgo = '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      if (diff.inDays == 1) {
        timeAgo = '1 day ago';
      } else {
        timeAgo = '${diff.inDays} days ago';
      }
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      timeAgo = '$weeks weeks ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      timeAgo = '$months months ago';
    } else {
      final years = (diff.inDays / 365).floor();
      timeAgo = '$years years ago';
    }

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
