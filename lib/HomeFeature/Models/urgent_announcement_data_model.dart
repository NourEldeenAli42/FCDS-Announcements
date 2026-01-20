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
    return UrgentUpdateDataModel(
      chipText: firestoreData['chipText'] ?? '',
      titleText: firestoreData['title'] ?? '',
      bodyText: firestoreData['description'] ?? '',
      timeText: firestoreData['timeText'] ?? '',
    );
  }
}
