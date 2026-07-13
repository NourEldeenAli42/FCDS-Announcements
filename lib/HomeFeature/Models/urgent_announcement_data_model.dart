import 'package:fcds_announcements/utils/date_formatter.dart';

class UrgentUpdateDataModel {
  String chipText;
  String titleText;
  String bodyText;
  String timeText;
  String redirectLink;
  int pageId;
  UrgentUpdateDataModel({
    required this.chipText,
    required this.titleText,
    required this.bodyText,
    required this.timeText,
    required this.pageId,
    required this.redirectLink,
  });
  factory UrgentUpdateDataModel.fromDocument(Map<String, dynamic> document) {
    final postDate = DateTime.parse(document['created_at']);

    String timeAgo = Dateformatter.getTimeAgo(postDate);

    // Replace the raw timestamp in the map with the formatted string so the return uses it
    document['post_time'] = timeAgo;
    return UrgentUpdateDataModel(
      chipText: document['chip_text'] ?? '',
      titleText: document['title'] ?? '',
      bodyText: document['content'] ?? '',
      timeText: timeAgo,
      pageId: document['page_id'] ?? 0,
      redirectLink: document['redirect_link'] ?? '',
    );
  }
}
