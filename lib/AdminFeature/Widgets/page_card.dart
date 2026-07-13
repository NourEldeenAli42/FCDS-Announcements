import 'package:fcds_announcements/FollowPageFeature/Data%20Models/course_data_model.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/page_chip.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class PageCard extends StatelessWidget {
  final Map<CourseDataModel, List<PageDataModel>> pageData;
  final Function(PageDataModel)? onEdit;
  final Function(PageDataModel)? onDelete;
  const PageCard({
    super.key,
    required this.pageData,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageData.keys.first.name,
          style: MyTextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ...pageData.values.first.map((page) {
          return Card(
            child: ListTile(
              title: Text(
                page.title,
                style: MyTextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                children: [
                  Wrap(
                    children: [
                      PageChip(tag: page.hall),
                      PageChip(tag: page.startTime.format(context)),
                      PageChip(tag: page.instructor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      TextButton(
                        onPressed: () {
                          onEdit?.call(page);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: MyTextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete?.call(page);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: MyTextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
